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
}
