import 'package:equatable/equatable.dart';

import '../../../data/models/user_settings.dart';

/// States for the settings bloc
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the settings bloc
class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// State when settings are being loaded
class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

/// State when settings have been loaded successfully
class SettingsLoaded extends SettingsState {
  /// The user settings
  final UserSettings settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// State when there's an error loading settings
class SettingsError extends SettingsState {
  /// The error message
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
