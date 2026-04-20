# Uber Driver App

A Flutter application for drivers — the companion app to the [Uber Passenger App](https://github.com/NajamL96/uber-passenger-app).

## Features

- Driver registration & login (Firebase Auth + Google Sign-In + Facebook Auth)
- Real-time trip requests via Firebase Realtime Database
- Live location tracking with Google Maps
- Accept/decline ride requests
- Turn-by-turn navigation to pickup & dropoff
- Earnings dashboard
- Trip history
- Driver ratings
- Push notifications for new ride requests
- Dark-themed Google Maps UI

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart) |
| Auth | Firebase Authentication |
| Database | Firebase Realtime Database + Cloud Firestore |
| Maps | Google Maps Flutter |
| Location | Geolocator + GeoFire |
| Notifications | Firebase Cloud Messaging |
| State Management | Provider |

## Getting Started

### Prerequisites

- Flutter SDK `>=2.16.2 <3.0.0`
- A Firebase project
- Google Maps API key with the following APIs enabled:
  - Maps SDK for Android / iOS
  - Directions API
  - Geocoding API
  - Places API

### Setup

1. **Clone the repo**
   ```bash
   git clone https://github.com/NajamL96/uber-driver-app.git
   cd uber-driver-app
   ```

2. **Add Firebase config files** (not included — create your own Firebase project)
   - Android: place `google-services.json` at `android/app/google-services.json`
   - iOS: place `GoogleService-Info.plist` at `ios/Runner/GoogleService-Info.plist`

3. **Add your Google Maps API key**

   Create `lib/global/map_key.dart`:
   ```dart
   String mapKey = "YOUR_GOOGLE_MAPS_API_KEY";
   ```

   Also add the key to:
   - Android: `android/app/src/main/AndroidManifest.xml` — replace `YOUR_GOOGLE_MAPS_API_KEY`
   - iOS: `ios/Runner/AppDelegate.swift` or `Info.plist`

4. **Install dependencies**
   ```bash
   flutter pub get
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── assistants/         # Helper methods (map logic, API calls)
├── authentication/     # Login & registration screens
├── global/             # Global variables & map key
├── infoHandler/        # App info state
├── mainScreens/        # Main app screens (new trip, history, etc.)
├── models/             # Data models
├── push_notifications/ # FCM notification handler
├── services/           # Background services
├── splashScreen/       # Splash screen
├── tabPages/           # Bottom tab pages (home, earnings, profile, ratings)
├── widgets/            # Reusable UI widgets
└── main.dart
```

## Related

- [Uber Passenger App](https://github.com/NajamL96/uber-passenger-app) — the rider-side companion app

## License

This project is for educational purposes.
