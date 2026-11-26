import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:southsea_cinema/screens/basket_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> _pumpUntilVisible(
  WidgetTester tester,
  String text,
) async {
  final finder = find.text(text);
  final stopwatch = Stopwatch()..start();

  while (finder.evaluate().isEmpty) {
    if (stopwatch.elapsed >= const Duration(seconds: 5)) {
      fail('Timed out waiting for "$text".');
    }

    await Future<void>.delayed(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 16));
  }
}

void main() {
  final cinemaDatabase = CinemaDatabase.instance;
  final cart = CartRepository.instance;

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() async {
    cart.clear();

    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    cinemaDatabase.setDatabase(db);
    await cinemaDatabase.createTables(db, 1);
  });

  tearDown(() async {
    await cinemaDatabase.close();
    cart.clear();
  });

  testWidgets('BasketScreen displays empty message when basket has no items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

    expect(find.text('Your basket is empty.'), findsOneWidget);
    expect(find.text('BUY TICKETS'), findsNothing);
  });

  testWidgets('BasketScreen displays tickets and total price', (
    WidgetTester tester,
  ) async {
    final Movie movie = MovieRepository().getMovies().first;
    cart.addItem(movie, 2);

    await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

    expect(find.text(movie.title.toUpperCase()), findsOneWidget);
    expect(find.text('2 Tickets'), findsOneWidget);
    expect(
      find.text('£${(movie.ticketPrice * 2).toStringAsFixed(2)}'),
      findsOneWidget,
    );
    expect(find.text('£4.00'), findsOneWidget);
    expect(
      find.text('£${cart.getTotalDue().toStringAsFixed(2)}'),
      findsOneWidget,
    );
    expect(find.text('BUY TICKETS'), findsOneWidget);
  });

  testWidgets('BasketScreen removes tickets when delete button is pressed', (
    WidgetTester tester,
  ) async {
    final Movie movie = MovieRepository().getMovies().first;
    cart.addItem(movie, 2);

    await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

    expect(find.text('2 Tickets'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.text('Your basket is empty.'), findsOneWidget);
    expect(find.text('2 Tickets'), findsNothing);
    expect(cart.getItems(), isEmpty);
  });

  testWidgets('checkout saves a numbered booking and clears the basket', (
    WidgetTester tester,
  ) async {
    final Movie movie = MovieRepository().getMovies().first;
    cart.addItem(movie, 2);

    await tester.runAsync(() async {
      await tester.pumpWidget(const MaterialApp(home: BasketScreen()));
      await _pumpUntilVisible(tester, 'No past bookings yet.');

      final buyButton = find.text('BUY TICKETS');
      await tester.ensureVisible(buyButton);
      await tester.pump();
      await tester.tap(buyButton);
      await _pumpUntilVisible(tester, 'Booking #1001');
    });

    expect(cart.getItems(), isEmpty);
    expect(find.text('Your basket is empty.'), findsOneWidget);
    expect(find.text('BUY TICKETS'), findsNothing);
    expect(find.text('Booking #1001 confirmed!'), findsOneWidget);
    expect(find.text('Booking #1001'), findsOneWidget);

    final bookings = await tester.runAsync(cinemaDatabase.getAllBookings);
    expect(bookings, hasLength(1));

    final booking = bookings!.single;
    expect(booking.bookingNumber, 1001);
    expect(booking.summary, '2 x ${movie.title}');
    expect(booking.total, 16.00);
  });

  testWidgets('shows a message when there are no past bookings', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const MaterialApp(home: BasketScreen()));
      await _pumpUntilVisible(tester, 'No past bookings yet.');
    });

    expect(find.text('Past bookings'), findsOneWidget);
    expect(find.text('No past bookings yet.'), findsOneWidget);
  });

  testWidgets('shows a saved booking even when the basket is empty', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await cinemaDatabase.insertBooking(
        const Booking(
          bookingNumber: 1001,
          summary: '2 x Arrival',
          total: 16.00,
          date: '26/11/2026 14:00',
        ),
      );

      await tester.pumpWidget(const MaterialApp(home: BasketScreen()));
      await _pumpUntilVisible(tester, 'Booking #1001');
    });

    expect(find.text('Your basket is empty.'), findsOneWidget);
    expect(find.text('Booking #1001'), findsOneWidget);
    expect(find.text('2 x Arrival\n26/11/2026 14:00'), findsOneWidget);
    expect(find.text('£16.00'), findsOneWidget);
  });
}