// lib/state/meal_plan_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_management_app/data/models/meal_plan.dart';
import 'package:food_management_app/data/repositories/meal_plan_repo.dart';


// Events
abstract class MealPlanEvent {}
class LoadMealPlans extends MealPlanEvent {}
class AddMealPlan extends MealPlanEvent {
  final MealPlan mealPlan;
  AddMealPlan(this.mealPlan);
}

// States
abstract class MealPlanState {}
class MealPlanInitial extends MealPlanState {}
class MealPlanLoading extends MealPlanState {}
class MealPlanLoaded extends MealPlanState {
  final List<MealPlan> mealPlans;
  MealPlanLoaded(this.mealPlans);
}
class MealPlanError extends MealPlanState {
  final String message;
  MealPlanError(this.message);
}

// BLoC
class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  final MealPlanRepository repository;

  MealPlanBloc(this.repository) : super(MealPlanInitial()) {
    on<LoadMealPlans>(_onLoadMealPlans);
    on<AddMealPlan>(_onAddMealPlan);
  }

  Future<void> _onLoadMealPlans(
    LoadMealPlans event,
    Emitter<MealPlanState> emit,
  ) async {
    emit(MealPlanLoading());
    try {
      final plans = await repository.getMealPlans();
      emit(MealPlanLoaded(plans));
    } catch (e) {
      emit(MealPlanError(e.toString()));
    }
  }

  Future<void> _onAddMealPlan(
    AddMealPlan event,
    Emitter<MealPlanState> emit,
  ) async {
    // Implementation for adding meal plan
  }
}