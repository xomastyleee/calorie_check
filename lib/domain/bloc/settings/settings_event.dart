import 'package:equatable/equatable.dart';

import '../../../data/models/user_settings.dart';

/// Events for the settings bloc
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load user settings
class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

/// Event to update the daily calorie limit
class UpdateCalorieLimit extends SettingsEvent {
  /// The new calorie limit
  final int calorieLimit;

  const UpdateCalorieLimit(this.calorieLimit);

  @override
  List<Object?> get props => [calorieLimit];
}

/// Event to update all user settings
class UpdateSettings extends SettingsEvent {
  /// The updated user settings
  final UserSettings settings;

  const UpdateSettings(this.settings);

  @override
  List<Object?> get props => [settings];
}
