import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dialog for setting the daily calorie limit
class CalorieLimitDialog extends StatefulWidget {
  /// The initial calorie limit
  final int initialLimit;

  /// Constructs a CalorieLimitDialog
  const CalorieLimitDialog({
    super.key,
    required this.initialLimit,
  });

  @override
  State<CalorieLimitDialog> createState() => _CalorieLimitDialogState();
}

class _CalorieLimitDialogState extends State<CalorieLimitDialog> {
  final _formKey = GlobalKey<FormState>();
  final _limitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _limitController.text = widget.initialLimit.toString();
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  void _saveLimit() {
    if (_formKey.currentState!.validate()) {
      final limit = int.parse(_limitController.text);
      Navigator.of(context).pop(limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Daily Calorie Limit'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _limitController,
          decoration: const InputDecoration(
            labelText: 'Daily Calorie Limit',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a calorie limit';
            }
            final limit = int.tryParse(value);
            if (limit == null || limit <= 0) {
              return 'Please enter a valid calorie limit';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveLimit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
