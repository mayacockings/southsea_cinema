import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/screens/basket_screen.dart';
import 'package:southsea_cinema/screens/settings_screen.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _lightModeKey = 'cinema_light_mode';

bool isSupportedPlatform() {
  if (kIsWeb) {
    return false;
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    return true;
  }
  return false;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!isSupportedPlatform()) {
    runApp(const UnsupportedPlatformApp());
    return;
  }

  bool useLightMode = false;
  try {
    useLightMode =
        await SharedPreferencesAsync().getBool(_lightModeKey) ?? false;
  } catch (error) {
    debugPrint('Could not load the saved theme: $error');
  }

  runApp(
    SouthseaCinemaApp(
      initialThemeMode: useLightMode ? ThemeMode.light : ThemeMode.dark,
    ),
  );
}

class SouthseaCinemaApp extends StatefulWidget {
  const SouthseaCinemaApp({
    super.key,
    this.initialThemeMode = ThemeMode.dark,
  });

  final ThemeMode initialThemeMode;

  @override
  State<SouthseaCinemaApp> createState() => _SouthseaCinemaAppState();
}

class _SouthseaCinemaAppState extends State<SouthseaCinemaApp> {
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();
  late ThemeMode _themeMode;
  bool _savingTheme = false;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: cinemaBrand,
          brightness: Brightness.light,
        ),
      ),
      themeMode: _themeMode,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: cinemaBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: cinemaBrand,
          brightness: Brightness.dark,
          primary: cinemaBrand,
          surface: cinemaSurface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: cinemaSurface,
          iconTheme: IconThemeData(color: cinemaBrand),
          titleTextStyle: cinemaHeaderStyle,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeView(),
        '/basket': (context) => const BasketScreen(),
        '/settings': (context) => Builder(
          builder: (context) {
            final bool isDark =
                Theme.of(context).brightness == Brightness.dark;

            return SettingsScreen(
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              onThemeModeChanged: (mode) async {
                if (_savingTheme || mode == _themeMode) {
                  return;
                }

                _savingTheme = true;

                try {
                  await _preferences.setBool(
                    _lightModeKey,
                    mode == ThemeMode.light,
                  );

                  if (mounted) {
                    setState(() {
                      _themeMode = mode;
                    });
                  }
                } catch (error) {
                  debugPrint('Could not save the theme: $error');

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not save the theme choice.'),
                      ),
                    );
                  }
                } finally {
                  _savingTheme = false;
                }
              },
            );
          },
        ),
      },
    );
  }
}

class UnsupportedPlatformApp extends StatelessWidget {
  const UnsupportedPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'This app saves orders with SQLite and is set up to run on '
              'Android only. Stop the app and run it on an Android emulator '
              'or device instead.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}