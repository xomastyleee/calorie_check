import 'package:bloc/bloc.dart';

import '../../../data/models/meal_entry.dart';
import '../../../domain/repositories/meal_repository.dart';
import 'meal_event.dart';
import 'meal_state.dart';

/// BLoC for managing meal entry data
class MealBloc extends Bloc<MealEvent, MealState> {
  final MealRepository _mealRepository;

  /// Constructs a MealBloc with a repository dependency
  MealBloc({required MealRepository mealRepository})
      : _mealRepository = mealRepository,
        super(const MealInitial()) {
    on<LoadMeals>(_onLoadMeals);
    on<LoadMealsForDate>(_onLoadMealsForDate);
    on<AddMeal>(_onAddMeal);
    on<UpdateMeal>(_onUpdateMeal);
    on<DeleteMeal>(_onDeleteMeal);
  }

  /// Handler for LoadMeals event
  Future<void> _onLoadMeals(
    LoadMeals event,
    Emitter<MealState> emit,
  ) async {
    emit(const MealLoading());
    try {
      final mealEntries = await _mealRepository.getAllMealEntries();
      emit(MealLoaded(mealEntries));
    } catch (e) {
      emit(MealError('Failed to load meal entries: ${e.toString()}'));
    }
  }

  /// Handler for LoadMealsForDate event
  Future<void> _onLoadMealsForDate(
    LoadMealsForDate event,
    Emitter<MealState> emit,
  ) async {
    emit(const MealLoading());
    try {
      final mealEntries =
          await _mealRepository.getMealEntriesForDate(event.date);
      emit(MealLoaded(mealEntries));
    } catch (e) {
      emit(MealError('Failed to load meal entries for date: ${e.toString()}'));
    }
  }

  /// Handler for AddMeal event
  Future<void> _onAddMeal(
    AddMeal event,
    Emitter<MealState> emit,
  ) async {
    final currentState = state;
    try {
      await _mealRepository.saveMealEntry(event.mealEntry);

      if (currentState is MealLoaded) {
        final updatedMealEntries =
            List<MealEntry>.from(currentState.mealEntries)
              ..add(event.mealEntry);
        emit(MealLoaded(updatedMealEntries));
      } else {
        add(const LoadMeals());
      }
    } catch (e) {
      emit(MealError('Failed to add meal entry: ${e.toString()}'));
    }
  }

  /// Handler for UpdateMeal event
  Future<void> _onUpdateMeal(
    UpdateMeal event,
    Emitter<MealState> emit,
  ) async {
    final currentState = state;
    try {
      await _mealRepository.saveMealEntry(event.mealEntry);

      if (currentState is MealLoaded) {
        final updatedMealEntries = currentState.mealEntries.map((mealEntry) {
          return mealEntry.id == event.mealEntry.id
              ? event.mealEntry
              : mealEntry;
        }).toList();
        emit(MealLoaded(updatedMealEntries));
      } else {
        add(const LoadMeals());
      }
    } catch (e) {
      emit(MealError('Failed to update meal entry: ${e.toString()}'));
    }
  }

  /// Handler for DeleteMeal event
  Future<void> _onDeleteMeal(
    DeleteMeal event,
    Emitter<MealState> emit,
  ) async {
    final currentState = state;
    try {
      await _mealRepository.deleteMealEntry(event.id);

      if (currentState is MealLoaded) {
        final updatedMealEntries = currentState.mealEntries
            .where((mealEntry) => mealEntry.id != event.id)
            .toList();
        emit(MealLoaded(updatedMealEntries));
      } else {
        add(const LoadMeals());
      }
    } catch (e) {
      emit(MealError('Failed to delete meal entry: ${e.toString()}'));
    }
  }
}
