import '../../data/models/meal_entry.dart';

/// Repository interface for meal entry operations
abstract class MealRepository {
  /// Get all meal entries for a specific date
  Future<List<MealEntry>> getMealEntriesForDate(DateTime date);

  /// Get all meal entries
  Future<List<MealEntry>> getAllMealEntries();

  /// Get a meal entry by ID
  Future<MealEntry?> getMealEntry(String id);

  /// Save a meal entry
  Future<void> saveMealEntry(MealEntry mealEntry);

  /// Delete a meal entry
  Future<void> deleteMealEntry(String id);
}
