import 'package:equatable/equatable.dart';

import '../../../data/models/meal_entry.dart';

/// Events for the meal bloc
abstract class MealEvent extends Equatable {
  const MealEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all meal entries
class LoadMeals extends MealEvent {
  const LoadMeals();
}

/// Event to load meal entries for a specific date
class LoadMealsForDate extends MealEvent {
  /// The date to load meals for
  final DateTime date;

  const LoadMealsForDate(this.date);

  @override
  List<Object?> get props => [date];
}

/// Event to add a new meal entry
class AddMeal extends MealEvent {
  /// The meal entry to add
  final MealEntry mealEntry;

  const AddMeal(this.mealEntry);

  @override
  List<Object?> get props => [mealEntry];
}

/// Event to update an existing meal entry
class UpdateMeal extends MealEvent {
  /// The meal entry to update
  final MealEntry mealEntry;

  const UpdateMeal(this.mealEntry);

  @override
  List<Object?> get props => [mealEntry];
}

/// Event to delete a meal entry
class DeleteMeal extends MealEvent {
  /// The ID of the meal entry to delete
  final String id;

  const DeleteMeal(this.id);

  @override
  List<Object?> get props => [id];
}
