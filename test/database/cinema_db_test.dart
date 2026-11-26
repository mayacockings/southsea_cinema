import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  final cinemaDatabase = CinemaDatabase.instance;

  const arrivalBooking = Booking(
    bookingNumber: 1001,
    summary: '2 x Arrival',
    total: 16.00,
    date: '26/11/2026 13:30',
  );

  const handmaidenBooking = Booking(
    bookingNumber: 1002,
    summary: '3 x The Handmaiden',
    total: 22.00,
    date: '26/11/2026 14:00',
  );

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    cinemaDatabase.setDatabase(db);
    await cinemaDatabase.createTables(db, 1);
  });

  tearDown(() async {
    await cinemaDatabase.close();
  });

  test('inserts a booking and reads back all its details', () async {
    final id = await cinemaDatabase.insertBooking(arrivalBooking);
    final bookings = await cinemaDatabase.getAllBookings();

    expect(id, greaterThan(0));
    expect(bookings, hasLength(1));

    final saved = bookings.single;
    expect(saved.id, id);
    expect(saved.bookingNumber, 1001);
    expect(saved.summary, '2 x Arrival');
    expect(saved.total, 16.00);
    expect(saved.date, '26/11/2026 13:30');
  });

  test('reads bookings with the highest booking number first', () async {
    await cinemaDatabase.insertBooking(arrivalBooking);
    await cinemaDatabase.insertBooking(handmaidenBooking);

    final bookings = await cinemaDatabase.getAllBookings();

    expect(bookings.map((booking) => booking.bookingNumber), [1002, 1001]);
  });

  test('starts booking numbers at 1001 when the table is empty', () async {
    expect(await cinemaDatabase.getAllBookings(), isEmpty);
    expect(await cinemaDatabase.getNextBookingNumber(), 1001);
  });

  test('returns one more than the highest saved booking number', () async {
    await cinemaDatabase.insertBooking(handmaidenBooking);
    await cinemaDatabase.insertBooking(arrivalBooking);

    expect(await cinemaDatabase.getNextBookingNumber(), 1003);
  });
}