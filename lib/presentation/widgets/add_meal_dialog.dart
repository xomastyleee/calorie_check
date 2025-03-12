import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/food_item.dart';
import '../../data/models/meal_entry.dart';
import '../../domain/bloc/food/food_bloc.dart';
import '../../domain/bloc/food/food_state.dart';

/// Dialog for adding a new meal entry
class AddMealDialog extends StatefulWidget {
  /// Constructs an AddMealDialog
  const AddMealDialog({super.key});

  @override
  State<AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<AddMealDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  String? _selectedFoodId;
  String _customFoodName = '';
  int _customCaloriesPer100g = 0;
  bool _isCustomFood = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _toggleCustomFood(bool value) {
    setState(() {
      _isCustomFood = value;
      if (value) {
        _selectedFoodId = null;
      }
    });
  }

  void _saveMeal() {
    if (_formKey.currentState!.validate()) {
      final amount = int.parse(_amountController.text);
      const uuid = Uuid();

      if (_isCustomFood) {
        // Calculate calories for custom food
        final calories = (_customCaloriesPer100g * amount) ~/ 100;

        final mealEntry = MealEntry(
          id: uuid.v4(),
          foodItemId: '',
          foodName: _customFoodName,
          amountInGrams: amount,
          date: DateTime.now(),
          calories: calories,
        );

        Navigator.of(context).pop(mealEntry);
      } else if (_selectedFoodId != null) {
        // Get the selected food item
        final foodState = context.read<FoodBloc>().state;
        if (foodState is FoodLoaded) {
          final selectedFood = foodState.foodItems
              .firstWhere((food) => food.id == _selectedFoodId);

          // Calculate calories
          final calories = (selectedFood.caloriesPer100g * amount) ~/ 100;

          final mealEntry = MealEntry(
            id: uuid.v4(),
            foodItemId: selectedFood.id,
            foodName: selectedFood.name,
            amountInGrams: amount,
            date: DateTime.now(),
            calories: calories,
          );

          Navigator.of(context).pop(mealEntry);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Meal'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Switch between existing food and custom food
              SwitchListTile(
                title: const Text('Custom Food'),
                value: _isCustomFood,
                onChanged: _toggleCustomFood,
              ),

              const SizedBox(height: 16.0),

              // Food selection or custom food input
              if (_isCustomFood) ...[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Food Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a food name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _customFoodName = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Calories per 100g',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter calories per 100g';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _customCaloriesPer100g = int.tryParse(value) ?? 0;
                  },
                ),
              ] else ...[
                BlocBuilder<FoodBloc, FoodState>(
                  builder: (context, state) {
                    if (state is FoodLoaded) {
                      final foodItems = state.foodItems;

                      if (foodItems.isEmpty) {
                        return const Text(
                          'No food items available. Add some food items first or use custom food.',
                        );
                      }

                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Select Food',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedFoodId,
                        items: foodItems.map((FoodItem food) {
                          return DropdownMenuItem<String>(
                            value: food.id,
                            child: Text(
                                '${food.name} (${food.caloriesPer100g} cal/100g)'),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a food item';
                          }
                          return null;
                        },
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedFoodId = newValue;
                          });
                        },
                      );
                    } else if (state is FoodLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return const Text('Error loading food items');
                    }
                  },
                ),
              ],

              const SizedBox(height: 16.0),

              // Amount input
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (grams)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveMeal,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
