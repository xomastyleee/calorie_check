import 'package:flutter/material.dart';

import '../../data/models/food_item.dart';

/// Widget for displaying a food item in a list
class FoodListItem extends StatelessWidget {
  /// The food item to display
  final FoodItem foodItem;

  /// Callback when the edit button is pressed
  final VoidCallback onEdit;

  /// Callback when the delete button is pressed
  final VoidCallback onDelete;

  /// Constructs a FoodListItem
  const FoodListItem({
    super.key,
    required this.foodItem,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Food name and calories
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodItem.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '${foodItem.caloriesPer100g} calories per 100g',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),

                // Edit and delete buttons
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: onDelete,
                ),
              ],
            ),

            // Description (if any)
            if (foodItem.description != null &&
                foodItem.description!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Text(
                foodItem.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
