import 'package:equatable/equatable.dart';

/// Model representing a daily log of calorie consumption
class DailyLog extends Equatable {
  /// Unique identifier for the daily log, typically the date string
  final String id;

  /// Date of the log
  final DateTime date;

  /// Calorie limit for this specific day
  final int calorieLimit;

  /// Total calories consumed on this day
  final int caloriesConsumed;

  /// List of meal entry IDs for this day
  final List<String> mealEntryIds;

  /// Constructs a DailyLog with required parameters
  const DailyLog({
    required this.id,
    required this.date,
    required this.calorieLimit,
    required this.caloriesConsumed,
    required this.mealEntryIds,
  });

  /// Creates a new DailyLog for the given date with default values
  factory DailyLog.create(DateTime date, int calorieLimit) {
    return DailyLog(
      id: date.toIso8601String().split('T')[0],
      date: DateTime(date.year, date.month, date.day),
      calorieLimit: calorieLimit,
      caloriesConsumed: 0,
      mealEntryIds: const [],
    );
  }

  /// Creates a copy of this DailyLog with the given fields replaced with new values
  DailyLog copyWith({
    String? id,
    DateTime? date,
    int? calorieLimit,
    int? caloriesConsumed,
    List<String>? mealEntryIds,
  }) {
    return DailyLog(
      id: id ?? this.id,
      date: date ?? this.date,
      calorieLimit: calorieLimit ?? this.calorieLimit,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      mealEntryIds: mealEntryIds ?? this.mealEntryIds,
    );
  }

  /// Adds a meal entry ID to this day's log and updates the total calories
  DailyLog addMealEntry(String mealEntryId, int calories) {
    return copyWith(
      mealEntryIds: [...mealEntryIds, mealEntryId],
      caloriesConsumed: caloriesConsumed + calories,
    );
  }

  /// Removes a meal entry ID from this day's log and updates the total calories
  DailyLog removeMealEntry(String mealEntryId, int calories) {
    return copyWith(
      mealEntryIds: mealEntryIds.where((id) => id != mealEntryId).toList(),
      caloriesConsumed: caloriesConsumed - calories,
    );
  }

  @override
  List<Object?> get props =>
      [id, date, calorieLimit, caloriesConsumed, mealEntryIds];
}
