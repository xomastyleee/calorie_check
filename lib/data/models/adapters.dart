import 'package:hive/hive.dart';

import 'daily_log.dart';
import 'food_item.dart';
import 'meal_entry.dart';
import 'user_settings.dart';

/// Adapter for FoodItem class
class FoodItemAdapter extends TypeAdapter<FoodItem> {
  @override
  final int typeId = 1;

  @override
  FoodItem read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final hasDescription = reader.readBool();
    final description = hasDescription ? reader.readString() : null;
    final caloriesPer100g = reader.readInt();

    return FoodItem(
      id: id,
      name: name,
      description: description,
      caloriesPer100g: caloriesPer100g,
    );
  }

  @override
  void write(BinaryWriter writer, FoodItem obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeBool(obj.description != null);
    if (obj.description != null) {
      writer.writeString(obj.description!);
    }
    writer.writeInt(obj.caloriesPer100g);
  }
}

/// Adapter for MealEntry class
class MealEntryAdapter extends TypeAdapter<MealEntry> {
  @override
  final int typeId = 2;

  @override
  MealEntry read(BinaryReader reader) {
    final id = reader.readString();
    final foodItemId = reader.readString();
    final foodName = reader.readString();
    final amountInGrams = reader.readInt();
    final date = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final calories = reader.readInt();

    return MealEntry(
      id: id,
      foodItemId: foodItemId,
      foodName: foodName,
      amountInGrams: amountInGrams,
      date: date,
      calories: calories,
    );
  }

  @override
  void write(BinaryWriter writer, MealEntry obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.foodItemId);
    writer.writeString(obj.foodName);
    writer.writeInt(obj.amountInGrams);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
    writer.writeInt(obj.calories);
  }
}

/// Adapter for UserSettings class
class UserSettingsAdapter extends TypeAdapter<UserSettings> {
  @override
  final int typeId = 3;

  @override
  UserSettings read(BinaryReader reader) {
    final dailyCalorieLimit = reader.readInt();

    return UserSettings(
      dailyCalorieLimit: dailyCalorieLimit,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer.writeInt(obj.dailyCalorieLimit);
  }
}

/// Adapter for DailyLog class
class DailyLogAdapter extends TypeAdapter<DailyLog> {
  @override
  final int typeId = 4;

  @override
  DailyLog read(BinaryReader reader) {
    final id = reader.readString();
    final date = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final calorieLimit = reader.readInt();
    final caloriesConsumed = reader.readInt();

    final mealEntryIdsLength = reader.readInt();
    final mealEntryIds = <String>[];
    for (var i = 0; i < mealEntryIdsLength; i++) {
      mealEntryIds.add(reader.readString());
    }

    return DailyLog(
      id: id,
      date: date,
      calorieLimit: calorieLimit,
      caloriesConsumed: caloriesConsumed,
      mealEntryIds: mealEntryIds,
    );
  }

  @override
  void write(BinaryWriter writer, DailyLog obj) {
    writer.writeString(obj.id);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
    writer.writeInt(obj.calorieLimit);
    writer.writeInt(obj.caloriesConsumed);

    writer.writeInt(obj.mealEntryIds.length);
    for (final id in obj.mealEntryIds) {
      writer.writeString(id);
    }
  }
}
