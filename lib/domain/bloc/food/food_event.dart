import 'package:equatable/equatable.dart';

import '../../../data/models/food_item.dart';

/// Events for the food bloc
abstract class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all food items
class LoadFoodItems extends FoodEvent {
  const LoadFoodItems();
}

/// Event to add a new food item
class AddFoodItem extends FoodEvent {
  /// The food item to add
  final FoodItem foodItem;

  const AddFoodItem(this.foodItem);

  @override
  List<Object?> get props => [foodItem];
}

/// Event to update an existing food item
class UpdateFoodItem extends FoodEvent {
  /// The food item to update
  final FoodItem foodItem;

  const UpdateFoodItem(this.foodItem);

  @override
  List<Object?> get props => [foodItem];
}

/// Event to delete a food item
class DeleteFoodItem extends FoodEvent {
  /// The ID of the food item to delete
  final String id;

  const DeleteFoodItem(this.id);

  @override
  List<Object?> get props => [id];
}
