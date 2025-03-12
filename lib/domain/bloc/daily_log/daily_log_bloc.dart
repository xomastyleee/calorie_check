import 'package:bloc/bloc.dart';

import '../../../data/models/daily_log.dart';
import '../../../domain/repositories/daily_log_repository.dart';
import '../../../domain/repositories/meal_repository.dart';
import '../../../domain/repositories/settings_repository.dart';
import 'daily_log_event.dart';
import 'daily_log_state.dart';

/// BLoC for managing daily log data
class DailyLogBloc extends Bloc<DailyLogEvent, DailyLogState> {
  final DailyLogRepository _dailyLogRepository;
  final MealRepository _mealRepository;
  final SettingsRepository _settingsRepository;

  /// Constructs a DailyLogBloc with repository dependencies
  DailyLogBloc({
    required DailyLogRepository dailyLogRepository,
    required MealRepository mealRepository,
    required SettingsRepository settingsRepository,
  })  : _dailyLogRepository = dailyLogRepository,
        _mealRepository = mealRepository,
        _settingsRepository = settingsRepository,
        super(const DailyLogInitial()) {
    on<LoadDailyLog>(_onLoadDailyLog);
    on<LoadAllDailyLogs>(_onLoadAllDailyLogs);
    on<AddMealToDailyLog>(_onAddMealToDailyLog);
    on<RemoveMealFromDailyLog>(_onRemoveMealFromDailyLog);
    on<UpdateDailyCalorieLimit>(_onUpdateDailyCalorieLimit);
  }

  /// Handler for LoadDailyLog event
  Future<void> _onLoadDailyLog(
    LoadDailyLog event,
    Emitter<DailyLogState> emit,
  ) async {
    emit(const DailyLogLoading());
    try {
      // Get or create daily log for the specified date
      DailyLog? dailyLog = await _dailyLogRepository.getDailyLog(event.date);

      if (dailyLog == null) {
        // If no log exists for this date, create a new one with default settings
        final settings = await _settingsRepository.getUserSettings();
        dailyLog = DailyLog.create(event.date, settings.dailyCalorieLimit);
        await _dailyLogRepository.saveDailyLog(dailyLog);
      }

      emit(DailyLogLoaded(dailyLog));
    } catch (e) {
      emit(DailyLogError('Failed to load daily log: ${e.toString()}'));
    }
  }

  /// Handler for LoadAllDailyLogs event
  Future<void> _onLoadAllDailyLogs(
    LoadAllDailyLogs event,
    Emitter<DailyLogState> emit,
  ) async {
    emit(const DailyLogLoading());
    try {
      final dailyLogs = await _dailyLogRepository.getAllDailyLogs();
      emit(AllDailyLogsLoaded(dailyLogs));
    } catch (e) {
      emit(DailyLogError('Failed to load all daily logs: ${e.toString()}'));
    }
  }

  /// Handler for AddMealToDailyLog event
  Future<void> _onAddMealToDailyLog(
    AddMealToDailyLog event,
    Emitter<DailyLogState> emit,
  ) async {
    try {
      // Save the meal entry first
      await _mealRepository.saveMealEntry(event.mealEntry);

      // Get or create daily log for the meal's date
      DailyLog? dailyLog =
          await _dailyLogRepository.getDailyLog(event.mealEntry.date);

      if (dailyLog == null) {
        // If no log exists for this date, create a new one with default settings
        final settings = await _settingsRepository.getUserSettings();
        dailyLog =
            DailyLog.create(event.mealEntry.date, settings.dailyCalorieLimit);
      }

      // Add the meal to the daily log
      final updatedLog =
          dailyLog.addMealEntry(event.mealEntry.id, event.mealEntry.calories);
      await _dailyLogRepository.saveDailyLog(updatedLog);

      emit(DailyLogLoaded(updatedLog));
    } catch (e) {
      emit(DailyLogError('Failed to add meal to daily log: ${e.toString()}'));
    }
  }

  /// Handler for RemoveMealFromDailyLog event
  Future<void> _onRemoveMealFromDailyLog(
    RemoveMealFromDailyLog event,
    Emitter<DailyLogState> emit,
  ) async {
    try {
      // Get the meal entry to find its date
      final mealEntry = await _mealRepository.getMealEntry(event.mealEntryId);

      if (mealEntry != null) {
        // Get the daily log for the meal's date
        final dailyLog = await _dailyLogRepository.getDailyLog(mealEntry.date);

        if (dailyLog != null) {
          // Remove the meal from the daily log
          final updatedLog =
              dailyLog.removeMealEntry(event.mealEntryId, event.calories);
          await _dailyLogRepository.saveDailyLog(updatedLog);

          // Delete the meal entry
          await _mealRepository.deleteMealEntry(event.mealEntryId);

          emit(DailyLogLoaded(updatedLog));
        }
      }
    } catch (e) {
      emit(DailyLogError(
          'Failed to remove meal from daily log: ${e.toString()}'));
    }
  }

  /// Handler for UpdateDailyCalorieLimit event
  Future<void> _onUpdateDailyCalorieLimit(
    UpdateDailyCalorieLimit event,
    Emitter<DailyLogState> emit,
  ) async {
    try {
      // Get the daily log for the specified date
      DailyLog? dailyLog = await _dailyLogRepository.getDailyLog(event.date);

      if (dailyLog != null) {
        // Update the calorie limit
        final updatedLog = dailyLog.copyWith(calorieLimit: event.calorieLimit);
        await _dailyLogRepository.saveDailyLog(updatedLog);

        emit(DailyLogLoaded(updatedLog));
      } else {
        // If no log exists for this date, create a new one with the specified limit
        final newLog = DailyLog.create(event.date, event.calorieLimit);
        await _dailyLogRepository.saveDailyLog(newLog);

        emit(DailyLogLoaded(newLog));
      }
    } catch (e) {
      emit(DailyLogError(
          'Failed to update daily calorie limit: ${e.toString()}'));
    }
  }
}
