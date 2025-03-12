import 'package:equatable/equatable.dart';

import '../../../data/models/food_item.dart';

/// States for the food bloc
abstract class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the food bloc
class FoodInitial extends FoodState {
  const FoodInitial();
}

/// State when food items are being loaded
class FoodLoading extends FoodState {
  const FoodLoading();
}

/// State when food items have been loaded successfully
class FoodLoaded extends FoodState {
  /// The list of food items
  final List<FoodItem> foodItems;

  const FoodLoaded(this.foodItems);

  @override
  List<Object?> get props => [foodItems];
}

/// State when there's an error loading food items
class FoodError extends FoodState {
  /// The error message
  final String message;

  const FoodError(this.message);

  @override
  List<Object?> get props => [message];
}
