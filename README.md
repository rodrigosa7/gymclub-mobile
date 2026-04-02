# Gym Club Flutter Test App

This folder contains a small Flutter client for testing the Gym Club backend.

## What it covers

- Browse exercises and routines
- Start a workout from a routine
- Log or complete workout sets
- Complete the active workout
- Review history and analytics

## Run it

1. Start the backend project on port `4000`:

   ```bash
   npm run dev
   ```

2. Fetch packages:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

## Backend URL

By default the app uses:

- `http://127.0.0.1:4000` on desktop, iOS simulator, and web
- `http://10.0.2.2:4000` on Android emulator

You can override it with:

```bash
flutter run --dart-define=API_BASE_URL=http://YOUR_MACHINE_IP:4000
```

Use your machine IP when testing from a physical device.
