import 'package:bloc/bloc.dart';

import '../../../domain/repositories/settings_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

/// BLoC for managing user settings
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;

  /// Constructs a SettingsBloc with a repository dependency
  SettingsBloc({required SettingsRepository settingsRepository})
      : _settingsRepository = settingsRepository,
        super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateCalorieLimit>(_onUpdateCalorieLimit);
    on<UpdateSettings>(_onUpdateSettings);
  }

  /// Handler for LoadSettings event
  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());
    try {
      final settings = await _settingsRepository.getUserSettings();
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError('Failed to load settings: ${e.toString()}'));
    }
  }

  /// Handler for UpdateCalorieLimit event
  Future<void> _onUpdateCalorieLimit(
    UpdateCalorieLimit event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    try {
      if (currentState is SettingsLoaded) {
        final updatedSettings = currentState.settings.copyWith(
          dailyCalorieLimit: event.calorieLimit,
        );
        await _settingsRepository.saveUserSettings(updatedSettings);
        emit(SettingsLoaded(updatedSettings));
      } else {
        // If not loaded, try to load first
        final settings = await _settingsRepository.getUserSettings();
        final updatedSettings = settings.copyWith(
          dailyCalorieLimit: event.calorieLimit,
        );
        await _settingsRepository.saveUserSettings(updatedSettings);
        emit(SettingsLoaded(updatedSettings));
      }
    } catch (e) {
      emit(SettingsError('Failed to update calorie limit: ${e.toString()}'));
    }
  }

  /// Handler for UpdateSettings event
  Future<void> _onUpdateSettings(
    UpdateSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _settingsRepository.saveUserSettings(event.settings);
      emit(SettingsLoaded(event.settings));
    } catch (e) {
      emit(SettingsError('Failed to update settings: ${e.toString()}'));
    }
  }
}
