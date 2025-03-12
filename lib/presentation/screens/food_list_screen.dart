import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/food_item.dart';
import '../../domain/bloc/food/food_bloc.dart';
import '../../domain/bloc/food/food_event.dart';
import '../../domain/bloc/food/food_state.dart';
import '../widgets/add_food_dialog.dart';
import '../widgets/food_list_item.dart';

/// Screen for displaying and managing food items
class FoodListScreen extends StatefulWidget {
  /// Constructs a FoodListScreen
  const FoodListScreen({super.key});

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FoodBloc>().add(const LoadFoodItems());
  }

  void _showAddFoodDialog() {
    final foodBloc = context.read<FoodBloc>();

    showDialog(
      context: context,
      builder: (context) => const AddFoodDialog(),
    ).then((foodItem) {
      if (foodItem != null && foodItem is FoodItem) {
        foodBloc.add(AddFoodItem(foodItem));
      }
    });
  }

  void _showEditFoodDialog(FoodItem foodItem) {
    final foodBloc = context.read<FoodBloc>();

    showDialog(
      context: context,
      builder: (context) => AddFoodDialog(foodItem: foodItem),
    ).then((updatedFoodItem) {
      if (updatedFoodItem != null && updatedFoodItem is FoodItem) {
        foodBloc.add(UpdateFoodItem(updatedFoodItem));
      }
    });
  }

  void _deleteFood(String id) {
    context.read<FoodBloc>().add(DeleteFoodItem(id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Items'),
      ),
      body: BlocBuilder<FoodBloc, FoodState>(
        builder: (context, state) {
          if (state is FoodLoaded) {
            final foodItems = state.foodItems;

            if (foodItems.isEmpty) {
              return const Center(
                child:
                    Text('No food items added yet. Add your first food item!'),
              );
            }

            return ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                final foodItem = foodItems[index];
                return FoodListItem(
                  foodItem: foodItem,
                  onEdit: () => _showEditFoodDialog(foodItem),
                  onDelete: () => _deleteFood(foodItem.id),
                );
              },
            );
          } else if (state is FoodLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FoodError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFoodDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
