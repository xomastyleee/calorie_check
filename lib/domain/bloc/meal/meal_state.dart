import 'package:equatable/equatable.dart';

import '../../../data/models/meal_entry.dart';

/// States for the meal bloc
abstract class MealState extends Equatable {
  const MealState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the meal bloc
class MealInitial extends MealState {
  const MealInitial();
}

/// State when meal entries are being loaded
class MealLoading extends MealState {
  const MealLoading();
}

/// State when meal entries have been loaded successfully
class MealLoaded extends MealState {
  /// The list of meal entries
  final List<MealEntry> mealEntries;

  const MealLoaded(this.mealEntries);

  @override
  List<Object?> get props => [mealEntries];
}

/// State when there's an error loading meal entries
class MealError extends MealState {
  /// The error message
  final String message;

  const MealError(this.message);

  @override
  List<Object?> get props => [message];
}
