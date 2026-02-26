# AGENTS.md

## Cursor Cloud specific instructions

### Project overview

Calorie Check is a Flutter mobile app for tracking daily calorie intake. It uses BLoC for state management and Hive for local NoSQL storage. There are no backend services, databases, or APIs — everything runs client-side.

### Prerequisites (pre-installed in the environment)

- **Flutter SDK 3.29.0** installed at `/opt/flutter/bin` (matching `.fvmrc`)
- **Android SDK** at `~/Android/sdk` with command-line tools, platform-tools, platforms;android-34, build-tools;34.0.0
- **Java 21** (OpenJDK, system package)
- PATH includes `/opt/flutter/bin` and Android SDK paths (configured in `~/.bashrc`)

### Key commands

| Action | Command |
|---|---|
| Install deps | `flutter pub get` |
| Format check | `dart format --output=none --set-exit-if-changed .` |
| Static analysis | `flutter analyze` |
| Code generation | `dart run build_runner build --delete-conflicting-outputs` |
| Build debug APK | `flutter build apk --debug` |
| Build web | `flutter build web` |
| Run web locally | `cd build/web && python3 -m http.server 8080` |

### Gotchas

- The `web/` directory was added for development/testing in the Cloud environment. The primary targets are Android/iOS.
- Hive initialization in `lib/data/local/hive_init.dart` uses `kIsWeb` to conditionally initialize: web uses `Hive.initFlutter()` (IndexedDB), mobile uses `Hive.initFlutter(appDir.path)`.
- There are no automated tests in the repository (the CI test step is commented out in `.github/workflows/flutter_ci.yml`).
- CI requires an `ENV_CONFIG` secret for creating a `.env` file. This is not needed for local development or analysis.
- `flutter doctor` will show warnings about missing Linux toolchain and Android Studio — these are safe to ignore for this project.
