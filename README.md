# Echion - Music Streaming App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.32-4CD2FD?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10-30B8F6?style=for-the-badge&logo=dart)
![Riverpod](https://img.shields.io/badge/Riverpod-3.2.0-2F5AA6?style=for-the-badge)
![Hive](https://img.shields.io/badge/Hive-1.1.0-FCC232?style=for-the-badge)

**A modern music streaming application built with Flutter featuring song playback, upload, and offline caching.**

</div>

---

## Features

- 🔐 **User Authentication** - Login and signup with secure token-based auth
- 🎵 **Music Streaming** - Stream songs directly from the API
- 📤 **Song Upload** - Upload your own songs with thumbnails
- ✏️ **Song Management** - Edit and delete your uploaded songs
- 💾 **Offline Caching** - Songs are cached for offline playback
- 🎨 **Theme Support** - Light, dark, and system theme modes
- 🔍 **Search** - Search songs by title or artist

## Tech Stack

| Category         | Technology                 |
| ---------------- | -------------------------- |
| Framework        | Flutter 3.32               |
| Language         | Dart 3.10                  |
| State Management | flutter_riverpod 3.2.0     |
| HTTP Client      | dio 5.7.0                  |
| Local Storage    | hive_flutter 1.1.0         |
| Audio Player     | just_audio 0.10.5          |
| Image Caching    | cached_network_image 3.4.1 |
| File Picker      | file_picker 10.3.8         |

## Project Structure

```
lib/
├── app/                    # App configuration & main screen
├── core/                   # Shared utilities & widgets
│   ├── data/              # Cache service
│   ├── utils/             # Validators, helpers
│   └── widgets/           # Reusable widgets
├── features/              # Feature modules
│   ├── auth/              # Authentication
│   │   ├── data/         # AuthService, UserModel
│   │   ├── presentation/ # Login, Signup pages
│   │   └── providers/    # AuthProvider
│   ├── songs/             # Songs feature
│   │   ├── data/         # SongService, SongModel
│   │   ├── presentation/ # Pages, widgets
│   │   └── providers/    # SongProvider, PlayerProvider
│   └── settings/          # App settings
│       ├── presentation/ # Settings page
│       └── providers/    # SettingsProvider
└── main.dart              # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK 3.32+
- Dart SDK 3.10+
- Android Studio / VS Code

### Installation

```bash
# Clone the repository
git clone https://github.com/dirgaydtm/echion.git
cd echion

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build APK

```bash
flutter build apk --release
```

## API Endpoints

The app connects to a REST API with the following endpoints:

| Method | Endpoint                  | Description       |
| ------ | ------------------------- | ----------------- |
| POST   | `/auth/signup`            | Register new user |
| POST   | `/auth/login`             | Login user        |
| GET    | `/auth/`                  | Get current user  |
| GET    | `/songs/getall`           | Get all songs     |
| GET    | `/songs/me`               | Get user's songs  |
| POST   | `/songs/upload`           | Upload new song   |
| PUT    | `/songs/update/{song_id}` | Update song       |
| DELETE | `/songs/delete/{song_id}` | Delete song       |

## Architecture

- **Feature-based Architecture** - Each feature is self-contained
- **Clean Separation** - Data, Presentation, and Provider layers
- **Riverpod Notifier Pattern** - Modern state management
- **Offline-First** - Cache data locally, sync with API

## License

This project is open source and available under the [MIT License](LICENSE).