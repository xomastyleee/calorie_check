import 'package:equatable/equatable.dart';

import '../../../data/models/meal_entry.dart';

/// Events for the daily log bloc
abstract class DailyLogEvent extends Equatable {
  const DailyLogEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load daily log for a specific date
class LoadDailyLog extends DailyLogEvent {
  /// The date to load the log for
  final DateTime date;

  const LoadDailyLog(this.date);

  @override
  List<Object?> get props => [date];
}

/// Event to load all daily logs
class LoadAllDailyLogs extends DailyLogEvent {
  const LoadAllDailyLogs();
}

/// Event to add a meal entry to the current day's log
class AddMealToDailyLog extends DailyLogEvent {
  /// The meal entry to add
  final MealEntry mealEntry;

  const AddMealToDailyLog(this.mealEntry);

  @override
  List<Object?> get props => [mealEntry];
}

/// Event to remove a meal entry from the current day's log
class RemoveMealFromDailyLog extends DailyLogEvent {
  /// The ID of the meal entry to remove
  final String mealEntryId;

  /// The calories to subtract
  final int calories;

  const RemoveMealFromDailyLog(this.mealEntryId, this.calories);

  @override
  List<Object?> get props => [mealEntryId, calories];
}

/// Event to update the calorie limit for a specific day
class UpdateDailyCalorieLimit extends DailyLogEvent {
  /// The date to update the limit for
  final DateTime date;

  /// The new calorie limit
  final int calorieLimit;

  const UpdateDailyCalorieLimit(this.date, this.calorieLimit);

  @override
  List<Object?> get props => [date, calorieLimit];
}
