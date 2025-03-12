import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repositories/food_repository.dart';
import '../models/food_item.dart';

/// Implementation of [FoodRepository] using Hive for storage
class FoodRepositoryImpl implements FoodRepository {
  final Box<FoodItem> _foodBox;
  final Uuid _uuid = const Uuid();

  /// Constructs a FoodRepositoryImpl with the required Hive box
  FoodRepositoryImpl(this._foodBox);

  @override
  Future<List<FoodItem>> getAllFoodItems() async {
    return _foodBox.values.toList();
  }

  @override
  Future<FoodItem?> getFoodItem(String id) async {
    return _foodBox.get(id);
  }

  @override
  Future<void> saveFoodItem(FoodItem foodItem) async {
    final id = foodItem.id.isEmpty ? _uuid.v4() : foodItem.id;
    final updatedItem = foodItem.copyWith(id: id);
    await _foodBox.put(id, updatedItem);
  }

  @override
  Future<void> deleteFoodItem(String id) async {
    await _foodBox.delete(id);
  }
}
