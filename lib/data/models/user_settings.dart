import 'package:equatable/equatable.dart';

/// Model representing user settings for calorie tracking
class UserSettings extends Equatable {
  /// Daily calorie limit set by the user
  final int dailyCalorieLimit;

  /// Constructs UserSettings with required parameters
  const UserSettings({
    required this.dailyCalorieLimit,
  });

  /// Default settings with a standard 2000 calorie diet
  factory UserSettings.defaultSettings() {
    return const UserSettings(
      dailyCalorieLimit: 2000,
    );
  }

  /// Creates a copy of this UserSettings with the given fields replaced with new values
  UserSettings copyWith({
    int? dailyCalorieLimit,
  }) {
    return UserSettings(
      dailyCalorieLimit: dailyCalorieLimit ?? this.dailyCalorieLimit,
    );
  }

  @override
  List<Object?> get props => [dailyCalorieLimit];
}
