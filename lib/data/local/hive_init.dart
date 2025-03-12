import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/adapters.dart';
import '../models/daily_log.dart';
import '../models/food_item.dart';
import '../models/meal_entry.dart';
import '../models/user_settings.dart';

/// Class for initializing Hive and registering adapters
class HiveInit {
  /// Box names for storage
  static const String foodBoxName = 'food_items';
  static const String mealBoxName = 'meal_entries';
  static const String settingsBoxName = 'user_settings';
  static const String dailyLogBoxName = 'daily_logs';

  /// Initialize Hive and register all adapters
  static Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDir.path);

    // Register Hive adapters
    Hive.registerAdapter(FoodItemAdapter());
    Hive.registerAdapter(MealEntryAdapter());
    Hive.registerAdapter(UserSettingsAdapter());
    Hive.registerAdapter(DailyLogAdapter());

    // Open boxes
    await Hive.openBox<FoodItem>(foodBoxName);
    await Hive.openBox<MealEntry>(mealBoxName);
    await Hive.openBox<UserSettings>(settingsBoxName);
    await Hive.openBox<DailyLog>(dailyLogBoxName);
  }

  /// Get the food items box
  static Box<FoodItem> getFoodBox() {
    return Hive.box<FoodItem>(foodBoxName);
  }

  /// Get the meal entries box
  static Box<MealEntry> getMealBox() {
    return Hive.box<MealEntry>(mealBoxName);
  }

  /// Get the user settings box
  static Box<UserSettings> getSettingsBox() {
    return Hive.box<UserSettings>(settingsBoxName);
  }

  /// Get the daily logs box
  static Box<DailyLog> getDailyLogBox() {
    return Hive.box<DailyLog>(dailyLogBoxName);
  }
}
