import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/booking.dart';

void main() {
  const newBooking = Booking(
    bookingNumber: 1001,
    summary: '2 x Arrival',
    total: 16.00,
    date: '26/11/2026 13:30',
  );

  test('toMap omits the id for a new booking', () {
    expect(newBooking.toMap(), {
      'booking_number': 1001,
      'summary': '2 x Arrival',
      'total': 16.00,
      'date': '26/11/2026 13:30',
    });
  });

  test('toMap includes the id for a saved booking', () {
    const savedBooking = Booking(
      id: 7,
      bookingNumber: 1001,
      summary: '2 x Arrival',
      total: 16.00,
      date: '26/11/2026 13:30',
    );

    expect(savedBooking.toMap(), {...newBooking.toMap(), 'id': 7});
  });

  test('fromMap restores all fields and converts an integer total', () {
    final booking = Booking.fromMap({
      'id': 7,
      'booking_number': 1001,
      'summary': '2 x Arrival',
      'total': 16,
      'date': '26/11/2026 13:30',
    });

    expect(booking.id, 7);
    expect(booking.bookingNumber, 1001);
    expect(booking.summary, '2 x Arrival');
    expect(booking.total, isA<double>());
    expect(booking.total, 16.00);
    expect(booking.date, '26/11/2026 13:30');
  });
}