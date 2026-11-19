import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/screens/settings_screen.dart';

void main() {
  testWidgets('settings screen displays customer form', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );

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

    await tester.enterText(find.byType(TextField).at(0), 'Alex Smith');
    await tester.enterText(find.byType(TextField).at(1), 'Portsmouth');
    await tester.enterText(
      find.byType(TextField).at(2),
      'alex@example.com',
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
    await tester.pump();

    expect(find.text('Settings saved for Alex Smith'), findsOneWidget);
  });
}
