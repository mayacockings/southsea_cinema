import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/user_settings.dart';

void main() {
  test('UserSettings has default values', () {
    final UserSettings settings = UserSettings();

    expect(settings.name, isEmpty);
    expect(settings.address, isEmpty);
    expect(settings.email, isEmpty);
    expect(settings.receiveNewsletter, isFalse);
  });

  test('UserSettings stores configured values', () {
    final UserSettings settings = UserSettings(
      name: 'Alex Smith',
      address: 'Portsmouth',
      email: 'alex@example.com',
      receiveNewsletter: true,
    );

    expect(settings.name, 'Alex Smith');
    expect(settings.address, 'Portsmouth');
    expect(settings.email, 'alex@example.com');
    expect(settings.receiveNewsletter, isTrue);
  });
}
