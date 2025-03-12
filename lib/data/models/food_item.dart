import 'package:equatable/equatable.dart';

/// Model representing a food item with its caloric information
class FoodItem extends Equatable {
  /// Unique identifier for the food item
  final String id;

  /// Name of the food item
  final String name;

  /// Optional description of the food item
  final String? description;

  /// Calories per 100 grams of the food item
  final int caloriesPer100g;

  /// Constructs a FoodItem with required parameters
  const FoodItem({
    required this.id,
    required this.name,
    this.description,
    required this.caloriesPer100g,
  });

  /// Creates a copy of this FoodItem with the given fields replaced with new values
  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    int? caloriesPer100g,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
    );
  }

  @override
  List<Object?> get props => [id, name, description, caloriesPer100g];
}
