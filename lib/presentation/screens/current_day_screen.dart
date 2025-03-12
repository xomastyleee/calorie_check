import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/models/meal_entry.dart';
import '../../domain/bloc/daily_log/daily_log_bloc.dart';
import '../../domain/bloc/daily_log/daily_log_event.dart';
import '../../domain/bloc/daily_log/daily_log_state.dart';
import '../../domain/bloc/meal/meal_bloc.dart';
import '../../domain/bloc/meal/meal_event.dart';
import '../../domain/bloc/meal/meal_state.dart';
import '../widgets/add_meal_dialog.dart';
import '../widgets/meal_list_item.dart';

/// Screen for displaying and managing the current day's meals and calories
class CurrentDayScreen extends StatefulWidget {
  /// Constructs a CurrentDayScreen
  const CurrentDayScreen({super.key});

  @override
  State<CurrentDayScreen> createState() => _CurrentDayScreenState();
}

class _CurrentDayScreenState extends State<CurrentDayScreen> {
  final DateTime _today = DateTime.now();
  final DateFormat _dateFormat = DateFormat('EEEE, MMMM d, yyyy');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<DailyLogBloc>().add(LoadDailyLog(_today));
    context.read<MealBloc>().add(LoadMealsForDate(_today));
  }

  void _showAddMealDialog() {
    // Сохраняем ссылки на блоки перед асинхронной операцией
    final dailyLogBloc = context.read<DailyLogBloc>();
    final mealBloc = context.read<MealBloc>();

    showDialog(
      context: context,
      builder: (context) => const AddMealDialog(),
    ).then((mealEntry) {
      if (mealEntry != null && mealEntry is MealEntry) {
        dailyLogBloc.add(AddMealToDailyLog(mealEntry));
        mealBloc.add(AddMeal(mealEntry));
      }
    });
  }

  void _deleteMeal(MealEntry mealEntry) {
    context.read<DailyLogBloc>().add(
          RemoveMealFromDailyLog(mealEntry.id, mealEntry.calories),
        );
    context.read<MealBloc>().add(DeleteMeal(mealEntry.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_dateFormat.format(_today)),
      ),
      body: Column(
        children: [
          // Calorie summary card
          BlocBuilder<DailyLogBloc, DailyLogState>(
            builder: (context, state) {
              if (state is DailyLogLoaded) {
                final dailyLog = state.dailyLog;
                final caloriesRemaining =
                    dailyLog.calorieLimit - dailyLog.caloriesConsumed;
                final progress =
                    dailyLog.caloriesConsumed / dailyLog.calorieLimit;

                return Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Daily Calorie Limit: ${dailyLog.calorieLimit}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8.0),
                        LinearProgressIndicator(
                          value: progress > 1.0 ? 1.0 : progress,
                          color: progress > 1.0 ? Colors.red : null,
                          minHeight: 10,
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Consumed: ${dailyLog.caloriesConsumed}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              'Remaining: $caloriesRemaining',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: caloriesRemaining < 0
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is DailyLogLoading) {
                return const Card(
                  margin: EdgeInsets.all(16.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),

          // Meal list
          Expanded(
            child: BlocBuilder<MealBloc, MealState>(
              builder: (context, state) {
                if (state is MealLoaded) {
                  final meals = state.mealEntries;

                  if (meals.isEmpty) {
                    return const Center(
                      child: Text('No meals added today. Add your first meal!'),
                    );
                  }

                  return ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return MealListItem(
                        meal: meal,
                        onDelete: () => _deleteMeal(meal),
                      );
                    },
                  );
                } else if (state is MealLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MealError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMealDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
