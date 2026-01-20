import 'package:equatable/equatable.dart';
import '../../../data/models/meal_item.dart';

abstract class SetPlanEvent extends Equatable {
  const SetPlanEvent();

  @override
  List<Object?> get props => [];
}

class InitializeSetPlan extends SetPlanEvent {
  final List<String> selectedMeals;
  const InitializeSetPlan(this.selectedMeals);
}

class UpdateMealTime extends SetPlanEvent {
  final String mealType;
  final String time;
  final bool isStartTime;

  const UpdateMealTime({required this.mealType, required this.time, required this.isStartTime});
}

class AddItemToMeal extends SetPlanEvent {
  final String mealType;
  final String name;
  const AddItemToMeal(this.mealType, this.name);
}

class RemoveItemFromMeal extends SetPlanEvent {
  final String mealType;
  final int index;
  const RemoveItemFromMeal(this.mealType, this.index);
}

class UpdateItemDiet extends SetPlanEvent {
  final String mealType;
  final int index;
  final String diet;
  const UpdateItemDiet({required this.mealType, required this.index, required this.diet});
}

class ToggleNewItemDiet extends SetPlanEvent {
  final String mealType;
  final bool isVeg;
  const ToggleNewItemDiet(this.mealType, this.isVeg);
}

class ToggleAddInput extends SetPlanEvent {
  final String mealType;
  final bool show;
  const ToggleAddInput(this.mealType, this.show);
}
