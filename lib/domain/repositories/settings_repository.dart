import '../../data/models/user_settings.dart';

/// Repository interface for user settings operations
abstract class SettingsRepository {
  /// Get user settings
  Future<UserSettings> getUserSettings();

  /// Save user settings
  Future<void> saveUserSettings(UserSettings settings);
}
