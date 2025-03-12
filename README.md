# Calorie Check

A mobile application for tracking calorie intake, developed with Flutter.

## Description

Calorie Check allows users to track their daily calorie intake, manage a list of food items, and view statistics of their eating habits. The application helps maintain a healthy lifestyle by controlling calorie consumption.

## Key Features

- **Daily Calorie Tracking** - record meals and monitor your total calories consumed
- **Food Item Management** - add, edit, and delete food items from your database
- **Calorie Goal Setting** - set your daily calorie limit
- **Statistics Viewing** - track your progress with charts and trends

## Technical Details

The application is built using:

- **Flutter** - cross-platform UI framework
- **BLoC** - state management architecture
- **Hive** - lightweight local NoSQL database for data storage
- **Material Design 3** - modern user interface

## Project Structure

The project is organized according to clean architecture principles:

- **lib/core/** - core utilities and constants
- **lib/data/** - data layer (models, data sources, repositories)
- **lib/domain/** - business logic (BLoC, entities, repository interfaces)
- **lib/presentation/** - user interface (screens, widgets)

## Installation and Running

1. Make sure Flutter is installed on your computer.
2. Clone the repository:
   ```
   git clone https://github.com/your-username/calorie_check.git
   ```
3. Navigate to the project directory:
   ```
   cd calorie_check
   ```
4. Install dependencies:
   ```
   flutter pub get
   ```
5. Run the application:
   ```
   flutter run
   ```

## Requirements

- Flutter 3.0.0 or higher
- Dart 2.17.0 or higher
- Connection to an iOS/Android device or emulator

## License

[MIT License](LICENSE)
