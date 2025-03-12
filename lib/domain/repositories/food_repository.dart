import '../../data/models/food_item.dart';

/// Repository interface for food item operations
abstract class FoodRepository {
  /// Get all food items
  Future<List<FoodItem>> getAllFoodItems();

  /// Get a food item by ID
  Future<FoodItem?> getFoodItem(String id);

  /// Save a food item
  Future<void> saveFoodItem(FoodItem foodItem);

  /// Delete a food item
  Future<void> deleteFoodItem(String id);
}
