import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/meal_item.dart';
import 'set_plan_event.dart';
import 'set_plan_state.dart';

class SetPlanBloc extends Bloc<SetPlanEvent, SetPlanState> {
  SetPlanBloc() : super(const SetPlanState()) {
    on<InitializeSetPlan>(_onInitialize);
    on<UpdateMealTime>(_onUpdateMealTime);
    on<AddItemToMeal>(_onAddItem);
    on<RemoveItemFromMeal>(_onRemoveItem);
    on<UpdateItemDiet>(_onUpdateItemDiet);
    on<ToggleNewItemDiet>(_onToggleNewItemDiet);
    on<ToggleAddInput>(_onToggleAddInput);
  }

  void _onInitialize(InitializeSetPlan event, Emitter<SetPlanState> emit) {
    final Map<String, MealData> initialData = {};
    for (var type in event.selectedMeals) {
      String start = '09:00';
      String end = '10:30';
      
      if (type == 'lunch') {
        start = '13:00'; end = '14:00';
      } else if (type == 'snacks') {
        start = '17:00'; end = '17:30';
      } else if (type == 'dinner') {
        start = '20:00'; end = '21:30';
      }

      initialData[type] = MealData(startTime: start, endTime: end);
    }
    emit(state.copyWith(mealData: initialData));
  }

  void _onUpdateMealTime(UpdateMealTime event, Emitter<SetPlanState> emit) {
    final currentMealData = state.mealData[event.mealType] ?? const MealData();
    final updatedMealData = event.isStartTime 
        ? currentMealData.copyWith(startTime: event.time) 
        : currentMealData.copyWith(endTime: event.time);
    
    final updatedMap = Map<String, MealData>.from(state.mealData);
    updatedMap[event.mealType] = updatedMealData;
    
    emit(state.copyWith(mealData: updatedMap));
  }

  void _onAddItem(AddItemToMeal event, Emitter<SetPlanState> emit) {
    final currentMealData = state.mealData[event.mealType] ?? const MealData();
    final newItem = MealItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: event.name,
      diet: currentMealData.newItemIsVeg ? 'veg' : 'non-veg',
      description: '',
    );
    
    final updatedItems = List<MealItem>.from(currentMealData.items)..add(newItem);
    // After adding, we want to clear the input field (handled by UI controller ideally, or rebuild)
    // And keep the "add input" visible or hide it? 
    // Usually keep it visible for multi-add, or toggle off. 
    // Let's keep it open but reset "newItemIsVeg" if desired.
    // The requirement says "UI should get updated".
    
    final updatedMealData = currentMealData.copyWith(
      items: updatedItems, 
      newItemIsVeg: true,
      // showAddInput: false // Uncomment if you want to close after adding one item
    );

    final updatedMap = Map<String, MealData>.from(state.mealData);
    updatedMap[event.mealType] = updatedMealData;

    emit(state.copyWith(mealData: updatedMap));
  }

  void _onRemoveItem(RemoveItemFromMeal event, Emitter<SetPlanState> emit) {
    final currentMealData = state.mealData[event.mealType];
    if (currentMealData == null) return;

    final updatedItems = List<MealItem>.from(currentMealData.items)..removeAt(event.index);
    final updatedMealData = currentMealData.copyWith(items: updatedItems);

    final updatedMap = Map<String, MealData>.from(state.mealData);
    updatedMap[event.mealType] = updatedMealData;

    emit(state.copyWith(mealData: updatedMap));
  }

  void _onUpdateItemDiet(UpdateItemDiet event, Emitter<SetPlanState> emit) {
    final currentMealData = state.mealData[event.mealType];
    if (currentMealData == null) return;

    final updatedItems = List<MealItem>.from(currentMealData.items);
    final item = updatedItems[event.index];
    updatedItems[event.index] = item.copyWith(diet: event.diet);

    final updatedMealData = currentMealData.copyWith(items: updatedItems);
    final updatedMap = Map<String, MealData>.from(state.mealData);
    updatedMap[event.mealType] = updatedMealData;

    emit(state.copyWith(mealData: updatedMap));
  }

  void _onToggleNewItemDiet(ToggleNewItemDiet event, Emitter<SetPlanState> emit) {
    final currentMealData = state.mealData[event.mealType] ?? const MealData();
    final updatedMealData = currentMealData.copyWith(newItemIsVeg: event.isVeg);

    final updatedMap = Map<String, MealData>.from(state.mealData);
    updatedMap[event.mealType] = updatedMealData;

    emit(state.copyWith(mealData: updatedMap));
  }

  void _onToggleAddInput(ToggleAddInput event, Emitter<SetPlanState> emit) {
    final currentMealData = state.mealData[event.mealType] ?? const MealData();
    final updatedMealData = currentMealData.copyWith(showAddInput: event.show);

    final updatedMap = Map<String, MealData>.from(state.mealData);
    updatedMap[event.mealType] = updatedMealData;

    emit(state.copyWith(mealData: updatedMap));
  }
}
