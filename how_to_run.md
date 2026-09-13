# Roam Travel Planner

A Flutter prototype for planning Malaysian trips, shared itineraries, hotels,
wallets, and travel-photo stories. The prototype starts as the default user
**Synthesize** and does not require a login.

## Run the app

### Prerequisites

- Install the [Flutter SDK](https://docs.flutter.dev/get-started/install).
- Install Android Studio and create an Android emulator, or connect an Android
  device with USB debugging enabled.
- Check the environment from a terminal:

  ```powershell
  flutter doctor
  ```

### Start on an emulator or device

1. Open a terminal in the project folder:

   ```powershell
   cd C:\Users\souyo\Downloads\Flutter\roam_travel_planner
   ```

2. Install the project packages:

   ```powershell
   flutter pub get
   ```

3. View available targets, then run the app:

   ```powershell
   flutter devices
   flutter run
   ```

   If more than one target is connected, use the device ID from `flutter devices`:

   ```powershell
   flutter run -d <device-id>
   ```

## Verify the project

Run static analysis and widget tests before sharing changes:

```powershell
flutter analyze
flutter test
```

## Build an Android APK

Create a debug APK:

```powershell
flutter build apk --debug
```

The generated file is located at:

```text
build\app\outputs\flutter-apk\app-debug.apk
```

For a distributable release build, configure Android signing first and run:

```powershell
flutter build apk --release
```
