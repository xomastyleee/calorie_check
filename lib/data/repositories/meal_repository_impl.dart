import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repositories/meal_repository.dart';
import '../models/meal_entry.dart';

/// Implementation of [MealRepository] using Hive for storage
class MealRepositoryImpl implements MealRepository {
  final Box<MealEntry> _mealBox;
  final Uuid _uuid = const Uuid();

  /// Constructs a MealRepositoryImpl with the required Hive box
  MealRepositoryImpl(this._mealBox);

  @override
  Future<List<MealEntry>> getMealEntriesForDate(DateTime date) async {
    final dateStr = _formatDate(date);
    return _mealBox.values
        .where((meal) => _formatDate(meal.date) == dateStr)
        .toList();
  }

  @override
  Future<List<MealEntry>> getAllMealEntries() async {
    return _mealBox.values.toList();
  }

  @override
  Future<MealEntry?> getMealEntry(String id) async {
    return _mealBox.get(id);
  }

  @override
  Future<void> saveMealEntry(MealEntry mealEntry) async {
    final id = mealEntry.id.isEmpty ? _uuid.v4() : mealEntry.id;
    final updatedEntry = mealEntry.copyWith(id: id);
    await _mealBox.put(id, updatedEntry);
  }

  @override
  Future<void> deleteMealEntry(String id) async {
    await _mealBox.delete(id);
  }

  /// Helper method to format date to year-month-day string for comparison
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
