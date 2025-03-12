import 'package:hive/hive.dart';

import '../../domain/repositories/settings_repository.dart';
import '../models/user_settings.dart';

/// Implementation of [SettingsRepository] using Hive for storage
class SettingsRepositoryImpl implements SettingsRepository {
  final Box<UserSettings> _settingsBox;
  static const String _settingsKey = 'user_settings';

  /// Constructs a SettingsRepositoryImpl with the required Hive box
  SettingsRepositoryImpl(this._settingsBox);

  @override
  Future<UserSettings> getUserSettings() async {
    final settings = _settingsBox.get(_settingsKey);
    if (settings == null) {
      final defaultSettings = UserSettings.defaultSettings();
      await saveUserSettings(defaultSettings);
      return defaultSettings;
    }
    return settings;
  }

  @override
  Future<void> saveUserSettings(UserSettings settings) async {
    await _settingsBox.put(_settingsKey, settings);
  }
}
