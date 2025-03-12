import 'package:flutter/material.dart';

import '../../data/models/meal_entry.dart';

/// Widget for displaying a meal entry in a list
class MealListItem extends StatelessWidget {
  /// The meal entry to display
  final MealEntry meal;

  /// Callback when the delete button is pressed
  final VoidCallback onDelete;

  /// Constructs a MealListItem
  const MealListItem({
    super.key,
    required this.meal,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Meal info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.foodName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${meal.amountInGrams}g',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // Calories
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${meal.calories} cal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'per ${meal.amountInGrams}g',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),

            // Delete button
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
