import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:southsea_cinema/main.dart' as cinema;
import 'package:southsea_cinema/views/home_view.dart';

const String _lightModeKey = 'cinema_light_mode';

Future<void> _startCinemaApp(WidgetTester tester) async {
  final TargetPlatform? previousPlatform = debugDefaultTargetPlatformOverride;
  debugDefaultTargetPlatformOverride = TargetPlatform.android;

  try {
    await tester.pumpWidget(await cinema.createStartupApp());
    await tester.pumpAndSettle();
  } finally {
    debugDefaultTargetPlatformOverride = previousPlatform;
  }
}

void main() {
  setUp(() {
    rootBundle.clear();
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('starts in dark mode when no theme is saved', (tester) async {
    await _startCinemaApp(tester);

    final home = tester.element(find.byType(HomeView));
    expect(Theme.of(home).brightness, Brightness.dark);
  });

  testWidgets('the Settings switch changes and saves both themes', (
    tester,
  ) async {
    await tester.pumpWidget(const cinema.SouthseaCinemaApp());
    await tester.pumpAndSettle();

    final home = tester.element(find.byType(HomeView));
    Navigator.of(home).pushNamed('/settings');
    await tester.pumpAndSettle();

    final lightModeTile = find.widgetWithText(SwitchListTile, 'Light mode');
    final preferences = SharedPreferencesAsync();

    await tester.ensureVisible(lightModeTile);
    await tester.pumpAndSettle();
    expect(tester.widget<SwitchListTile>(lightModeTile).value, isFalse);

    await tester.tap(lightModeTile);
    await tester.pumpAndSettle();

    expect(tester.widget<SwitchListTile>(lightModeTile).value, isTrue);
    expect(
      Theme.of(tester.element(lightModeTile)).brightness,
      Brightness.light,
    );
    expect(await preferences.getBool(_lightModeKey), isTrue);

    await tester.tap(lightModeTile);
    await tester.pumpAndSettle();

    expect(tester.widget<SwitchListTile>(lightModeTile).value, isFalse);
    expect(
      Theme.of(tester.element(lightModeTile)).brightness,
      Brightness.dark,
    );
    expect(await preferences.getBool(_lightModeKey), isFalse);
  });

  testWidgets('restores light mode from a saved choice at startup', (
    tester,
  ) async {
    await SharedPreferencesAsync().setBool(_lightModeKey, true);
    await _startCinemaApp(tester);

    final home = tester.element(find.byType(HomeView));
    expect(Theme.of(home).brightness, Brightness.light);
  });
}
