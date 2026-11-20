import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('settings screen displays customer form', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('My Settings'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Patron Number'), findsOneWidget);
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Receive news by email'), findsOneWidget);

    expect(find.byType(TextField), findsNWidgets(4));
    expect(find.byType(Switch), findsOneWidget);

    expect(find.text('CANCEL'), findsOneWidget);
    expect(find.text('SAVE SETTINGS'), findsOneWidget);
  });

  testWidgets('customer can enter and save settings', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Maya Cockings');
    await tester.enterText(find.byType(TextField).at(1), 'Gosport');
    await tester.enterText(
      find.byType(TextField).at(2),
      'maya@test.com',
    );
    await tester.enterText(find.byType(TextField).at(3), '1234');

    await tester.ensureVisible(find.byType(Switch));
    await tester.pump();

    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);

    await tester.ensureVisible(find.text('SAVE SETTINGS'));
    await tester.pump();

    await tester.tap(find.text('SAVE SETTINGS'));
    await tester.pumpAndSettle();

    expect(find.text('Settings saved for Maya Cockings'), findsOneWidget);
  });

  testWidgets('settings screen loads previously saved preferences',
      (tester) async {
    final preferences = SharedPreferencesAsync();

    await preferences.setString('cinema_name', 'Maya Cockings');
    await preferences.setString('cinema_address', 'Gosport');
    await preferences.setString('cinema_email', 'maya@test.com');
    await preferences.setString('cinema_patron_number', '1234');
    await preferences.setBool('cinema_receive_newsletter', true);

    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
        tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
        'Maya Cockings');
    expect(
        tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text,
        'Gosport');
    expect(
        tester.widget<TextField>(find.byType(TextField).at(2)).controller!.text,
        'maya@test.com');
    expect(
        tester.widget<TextField>(find.byType(TextField).at(3)).controller!.text,
        '1234');

    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
  });

  testWidgets('saving edited settings updates stored preferences',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Maya Cockings');
    await tester.enterText(find.byType(TextField).at(1), 'Gosport');
    await tester.enterText(
      find.byType(TextField).at(2),
      'maya@test.com',
    );
    await tester.enterText(find.byType(TextField).at(3), '5678');

    await tester.ensureVisible(find.byType(Switch));
    await tester.pump();

    await tester.tap(find.byType(Switch));
    await tester.pump();

    await tester.ensureVisible(find.text('SAVE SETTINGS'));
    await tester.pump();

    await tester.tap(find.text('SAVE SETTINGS'));
    await tester.pumpAndSettle();

    final preferences = SharedPreferencesAsync();

    expect(await preferences.getString('cinema_name'), 'Jamie Taylor');
    expect(await preferences.getString('cinema_address'), 'Brighton');
    expect(await preferences.getString('cinema_email'), 'jamie@example.com');
    expect(await preferences.getString('cinema_patron_number'), '5678');
    expect(await preferences.getBool('cinema_receive_newsletter'), true);
  });

  testWidgets('reopening settings restores saved preferences', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Maya Cockings');
    await tester.enterText(find.byType(TextField).at(1), 'Gosport');
    await tester.enterText(
      find.byType(TextField).at(2),
      'maya@test.com',
    );
    await tester.enterText(find.byType(TextField).at(3), '1234');

    await tester.ensureVisible(find.byType(Switch));
    await tester.pump();
    await tester.tap(find.byType(Switch));
    await tester.pump();

    await tester.ensureVisible(find.text('SAVE SETTINGS'));
    await tester.pump();
    await tester.tap(find.text('SAVE SETTINGS'));
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
        tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
        'Maya Cockings');
    expect(
        tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text,
        'Gosport');
    expect(
        tester.widget<TextField>(find.byType(TextField).at(2)).controller!.text,
        'maya@test.com');
    expect(
        tester.widget<TextField>(find.byType(TextField).at(3)).controller!.text,
        '1234');

    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
  });
}
