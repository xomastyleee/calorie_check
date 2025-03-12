import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/food_item.dart';

/// Dialog for adding or editing a food item
class AddFoodDialog extends StatefulWidget {
  /// The food item to edit, or null if adding a new food item
  final FoodItem? foodItem;

  /// Constructs an AddFoodDialog
  const AddFoodDialog({super.key, this.foodItem});

  @override
  State<AddFoodDialog> createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<AddFoodDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _caloriesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // If editing an existing food item, populate the form
    if (widget.foodItem != null) {
      _nameController.text = widget.foodItem!.name;
      if (widget.foodItem!.description != null) {
        _descriptionController.text = widget.foodItem!.description!;
      }
      _caloriesController.text = widget.foodItem!.caloriesPer100g.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  void _saveFood() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text;
      final calories = int.parse(_caloriesController.text);

      if (widget.foodItem != null) {
        // Update existing food item
        final updatedFood = widget.foodItem!.copyWith(
          name: name,
          description: description,
          caloriesPer100g: calories,
        );

        Navigator.of(context).pop(updatedFood);
      } else {
        // Create new food item
        const uuid = Uuid();
        final newFood = FoodItem(
          id: uuid.v4(),
          name: name,
          description: description,
          caloriesPer100g: calories,
        );

        Navigator.of(context).pop(newFood);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.foodItem != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Food' : 'Add Food'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
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
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _caloriesController,
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
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid calorie value';
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
          onPressed: _saveFood,
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
