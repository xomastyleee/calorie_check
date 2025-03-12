import 'package:bloc/bloc.dart';

import '../../../data/models/food_item.dart';
import '../../../domain/repositories/food_repository.dart';
import 'food_event.dart';
import 'food_state.dart';

/// BLoC for managing food item data
class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRepository _foodRepository;

  /// Constructs a FoodBloc with a repository dependency
  FoodBloc({required FoodRepository foodRepository})
      : _foodRepository = foodRepository,
        super(const FoodInitial()) {
    on<LoadFoodItems>(_onLoadFoodItems);
    on<AddFoodItem>(_onAddFoodItem);
    on<UpdateFoodItem>(_onUpdateFoodItem);
    on<DeleteFoodItem>(_onDeleteFoodItem);
  }

  /// Handler for LoadFoodItems event
  Future<void> _onLoadFoodItems(
    LoadFoodItems event,
    Emitter<FoodState> emit,
  ) async {
    emit(const FoodLoading());
    try {
      final foodItems = await _foodRepository.getAllFoodItems();
      emit(FoodLoaded(foodItems));
    } catch (e) {
      emit(FoodError('Failed to load food items: ${e.toString()}'));
    }
  }

  /// Handler for AddFoodItem event
  Future<void> _onAddFoodItem(
    AddFoodItem event,
    Emitter<FoodState> emit,
  ) async {
    final currentState = state;
    try {
      await _foodRepository.saveFoodItem(event.foodItem);

      if (currentState is FoodLoaded) {
        final updatedFoodItems = List<FoodItem>.from(currentState.foodItems)
          ..add(event.foodItem);
        emit(FoodLoaded(updatedFoodItems));
      } else {
        add(const LoadFoodItems());
      }
    } catch (e) {
      emit(FoodError('Failed to add food item: ${e.toString()}'));
    }
  }

  /// Handler for UpdateFoodItem event
  Future<void> _onUpdateFoodItem(
    UpdateFoodItem event,
    Emitter<FoodState> emit,
  ) async {
    final currentState = state;
    try {
      await _foodRepository.saveFoodItem(event.foodItem);

      if (currentState is FoodLoaded) {
        final updatedFoodItems = currentState.foodItems.map((foodItem) {
          return foodItem.id == event.foodItem.id ? event.foodItem : foodItem;
        }).toList();
        emit(FoodLoaded(updatedFoodItems));
      } else {
        add(const LoadFoodItems());
      }
    } catch (e) {
      emit(FoodError('Failed to update food item: ${e.toString()}'));
    }
  }

  /// Handler for DeleteFoodItem event
  Future<void> _onDeleteFoodItem(
    DeleteFoodItem event,
    Emitter<FoodState> emit,
  ) async {
    final currentState = state;
    try {
      await _foodRepository.deleteFoodItem(event.id);

      if (currentState is FoodLoaded) {
        final updatedFoodItems = currentState.foodItems
            .where((foodItem) => foodItem.id != event.id)
            .toList();
        emit(FoodLoaded(updatedFoodItems));
      } else {
        add(const LoadFoodItems());
      }
    } catch (e) {
      emit(FoodError('Failed to delete food item: ${e.toString()}'));
    }
  }
}
