import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/user_settings.dart';

void main() {
  test('UserSettings has default values', () {
    final UserSettings settings = UserSettings();

    expect(settings.name, '');
    expect(settings.address, '');
    expect(settings.email, '');
    expect(settings.patronNumber, '');
    expect(settings.receiveNewsletter, isFalse);
  });

  test('UserSettings stores customer details', () {
    final UserSettings settings = UserSettings(
      name: 'Maya Cockings',
      address: 'Gosport',
      email: 'maya@test.com',
      patronNumber: '1234',
      receiveNewsletter: true,
    );

    expect(settings.name, 'Maya Cockings');
    expect(settings.address, 'Gosport');
    expect(settings.email, 'maya@test.com');
    expect(settings.patronNumber, '1234');
    expect(settings.receiveNewsletter, isTrue);
  });
}
