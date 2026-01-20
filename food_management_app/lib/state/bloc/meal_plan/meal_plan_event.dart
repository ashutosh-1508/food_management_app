part of 'meal_plan_bloc.dart';

abstract class MealPlanEvent extends Equatable {
  const MealPlanEvent();

  @override
  List<Object> get props => [];
}

class LoadMealPlans extends MealPlanEvent {}

class AddMealPlan extends MealPlanEvent {
  final MealPlan plan;
  const AddMealPlan(this.plan);
   @override
  List<Object> get props => [plan];
}
