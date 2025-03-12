import 'package:equatable/equatable.dart';

/// Model representing a meal entry in a daily diet
class MealEntry extends Equatable {
  /// Unique identifier for the meal entry
  final String id;

  /// Reference to the food item ID
  final String foodItemId;

  /// Name of the food item (used for dynamic entries not in the database)
  final String foodName;

  /// Amount of food in grams
  final int amountInGrams;

  /// Date of the meal entry
  final DateTime date;

  /// Calories for this meal entry (calculated from amount and calories per 100g)
  final int calories;

  /// Constructs a MealEntry with required parameters
  const MealEntry({
    required this.id,
    required this.foodItemId,
    required this.foodName,
    required this.amountInGrams,
    required this.date,
    required this.calories,
  });

  /// Creates a copy of this MealEntry with the given fields replaced with new values
  MealEntry copyWith({
    String? id,
    String? foodItemId,
    String? foodName,
    int? amountInGrams,
    DateTime? date,
    int? calories,
  }) {
    return MealEntry(
      id: id ?? this.id,
      foodItemId: foodItemId ?? this.foodItemId,
      foodName: foodName ?? this.foodName,
      amountInGrams: amountInGrams ?? this.amountInGrams,
      date: date ?? this.date,
      calories: calories ?? this.calories,
    );
  }

  @override
  List<Object?> get props =>
      [id, foodItemId, foodName, amountInGrams, date, calories];
}
