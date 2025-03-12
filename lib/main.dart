import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/local/hive_init.dart';
import 'data/repositories/daily_log_repository_impl.dart';
import 'data/repositories/food_repository_impl.dart';
import 'data/repositories/meal_repository_impl.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'domain/bloc/daily_log/daily_log_bloc.dart';
import 'domain/bloc/food/food_bloc.dart';
import 'domain/bloc/meal/meal_bloc.dart';
import 'domain/bloc/settings/settings_bloc.dart';
import 'domain/repositories/daily_log_repository.dart';
import 'domain/repositories/food_repository.dart';
import 'domain/repositories/meal_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveInit.init();

  // Get Hive boxes
  final foodBox = HiveInit.getFoodBox();
  final mealBox = HiveInit.getMealBox();
  final settingsBox = HiveInit.getSettingsBox();
  final dailyLogBox = HiveInit.getDailyLogBox();

  // Create repositories
  final FoodRepository foodRepository = FoodRepositoryImpl(foodBox);
  final MealRepository mealRepository = MealRepositoryImpl(mealBox);
  final SettingsRepository settingsRepository =
      SettingsRepositoryImpl(settingsBox);
  final DailyLogRepository dailyLogRepository =
      DailyLogRepositoryImpl(dailyLogBox);

  runApp(
    CalorieCheckApp(
      foodRepository: foodRepository,
      mealRepository: mealRepository,
      settingsRepository: settingsRepository,
      dailyLogRepository: dailyLogRepository,
    ),
  );
}

/// Main application widget
class CalorieCheckApp extends StatelessWidget {
  final FoodRepository foodRepository;
  final MealRepository mealRepository;
  final SettingsRepository settingsRepository;
  final DailyLogRepository dailyLogRepository;

  /// Constructs a CalorieCheckApp with required repositories
  const CalorieCheckApp({
    super.key,
    required this.foodRepository,
    required this.mealRepository,
    required this.settingsRepository,
    required this.dailyLogRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FoodBloc>(
          create: (context) => FoodBloc(foodRepository: foodRepository),
        ),
        BlocProvider<MealBloc>(
          create: (context) => MealBloc(mealRepository: mealRepository),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) =>
              SettingsBloc(settingsRepository: settingsRepository),
        ),
        BlocProvider<DailyLogBloc>(
          create: (context) => DailyLogBloc(
            dailyLogRepository: dailyLogRepository,
            mealRepository: mealRepository,
            settingsRepository: settingsRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Calorie Check',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
