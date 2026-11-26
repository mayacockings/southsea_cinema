# Southsea Cinema

A Flutter cinema booking app for browsing films, selecting tickets,
reviewing an order, and managing saved profile settings.

## Features

- Browse a film catalogue loaded from a bundled JSON file.
- Open a film listing and add 1–5 tickets at a time to the basket.
- Review basket items, remove films, and see the total including the
  £4.00 service charge.
- Save bookings and view past bookings stored locally in SQLite.
- Save a name, address, email address, patron number, and newsletter
  preference.
- Switch between light and dark themes. The choice is saved between
  app launches.

## Platform

This project is configured to run on Android and stores booking history
locally in SQLite.

## Getting started

### Prerequisites

- Flutter SDK
- Android Studio with the Android SDK
- An Android emulator or a connected Android device

### Clone the repository

```bash
git clone https://github.com/mayacockings/southsea_cinema.git
cd southsea_cinema
```

### Install dependencies

```bash
flutter pub get
```

### Run the app

Start an emulator from Android Studio’s Device Manager or connect an
Android device. Then check the device ID:

```bash
flutter devices
```

Run the app using the Android device ID shown in the output. For example:

```bash
flutter run -d emulator-5554
```

In VS Code, select **Southsea Cinema (Android)** from the Run and Debug
dropdown and press **F5**. This launch configuration targets
`emulator-5554`. If your device has a different ID, use the terminal
command with your ID.

## Tests

Run the full test suite:

```bash
flutter test
```

The tests cover app startup, the film catalogue and listings, basket
operations, SQLite booking storage, saved profile settings, theme
switching and persistence, and the primary button.

## Project structure

| Path | Purpose |
| --- | --- |
| `lib/main.dart` | App startup, routes, and themes |
| `lib/constants.dart` | Shared app title and visual constants |
| `lib/database/` | SQLite booking storage |
| `lib/models/` | Film, basket item, booking, and profile models |
| `lib/repositories/` | Film catalogue and in-memory basket |
| `lib/screens/` | Basket and settings screens |
| `lib/views/` | Home catalogue and film details |
| `lib/widgets/` | Reusable film cards, drawer, and buttons |
| `assets/data/movies.json` | Bundled film catalogue |
| `assets/images/` | Film posters |
| `test/` | Automated tests |
| `pubspec.yaml` | Project dependencies and asset declarations |