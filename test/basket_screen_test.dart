
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:southsea_cinema/screens/basket_screen.dart';

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  testWidgets('BasketScreen displays empty message when basket has no items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: BasketScreen()),
    );

    expect(find.text('Your basket is empty.'), findsOneWidget);
    expect(find.text('BUY TICKETS'), findsNothing);
  });

  testWidgets('BasketScreen displays tickets and total price', (
    WidgetTester tester,
  ) async {
    final Movie movie = MovieRepository().getMovies().first;

    CartRepository.instance.addItem(movie, 2);

    await tester.pumpWidget(
      const MaterialApp(home: BasketScreen()),
    );

    expect(
      find.text(movie.title.toUpperCase()),
      findsOneWidget,
    );

    expect(find.text('2 Tickets'), findsOneWidget);

    expect(
      find.text('£${(movie.ticketPrice * 2).toStringAsFixed(2)}'),
      findsOneWidget,
    );

    expect(find.text('£4.00'), findsOneWidget);

    expect(
      find.text(
        '£${CartRepository.instance.getTotalDue().toStringAsFixed(2)}',
      ),
      findsOneWidget,
    );

    expect(find.text('BUY TICKETS'), findsOneWidget);
  });

  testWidgets('BasketScreen removes tickets when delete button is pressed', (
    WidgetTester tester,
  ) async {
    final Movie movie = MovieRepository().getMovies().first;

    CartRepository.instance.addItem(movie, 2);

    await tester.pumpWidget(
      const MaterialApp(home: BasketScreen()),
    );

    expect(find.text('2 Tickets'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.text('Your basket is empty.'), findsOneWidget);
    expect(find.text('2 Tickets'), findsNothing);
    expect(CartRepository.instance.getItems(), isEmpty);
  });

  testWidgets('BasketScreen clears basket when buying tickets', (
    WidgetTester tester,
  ) async {
    final Movie movie = MovieRepository().getMovies().first;

    CartRepository.instance.addItem(movie, 2);

    await tester.pumpWidget(
      const MaterialApp(home: BasketScreen()),
    );

    expect(find.text('2 Tickets'), findsOneWidget);
    expect(find.text('BUY TICKETS'), findsOneWidget);

    await tester.tap(find.text('BUY TICKETS'));
    await tester.pump();

    expect(CartRepository.instance.getItems(), isEmpty);

    expect(find.text('Your basket is empty.'), findsOneWidget);

    expect(
      find.text('Your tickets have been booked successfully!'),
      findsOneWidget,
    );

    expect(find.text('BUY TICKETS'), findsNothing);
  });
}
