import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/meal_plan.dart';
import '../../../data/repositories/food_repository.dart';

part 'meal_plan_event.dart';
part 'meal_plan_state.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  final FoodRepository repository;

  MealPlanBloc({required this.repository}) : super(MealPlanInitial()) {
    on<LoadMealPlans>(_onLoadMealPlans);
    on<AddMealPlan>(_onAddMealPlan);
  }

  Future<void> _onLoadMealPlans(LoadMealPlans event, Emitter<MealPlanState> emit) async {
    emit(MealPlanLoading());
    try {
      final plans = await repository.getMealPlans();
      emit(MealPlanLoaded(plans));
    } catch (e) {
      emit(MealPlanError(e.toString()));
    }
  }

  Future<void> _onAddMealPlan(AddMealPlan event, Emitter<MealPlanState> emit) async {
     if (state is MealPlanLoaded) {
       final currentPlans = (state as MealPlanLoaded).plans;
       // Create new list to ensure state change
       emit(MealPlanLoaded(List.from(currentPlans)..add(event.plan)));
       // In real app, call repository.addMealPlan(event.plan)
     }
  }
}
