import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/meal_plan.dart';

class MealTrackUiState extends Equatable {
  final int selectedDayIndex;
  final MealPlan? selectedPlan;

  const MealTrackUiState({
    required this.selectedDayIndex,
    this.selectedPlan,
  });

  MealTrackUiState copyWith({
    int? selectedDayIndex,
    MealPlan? selectedPlan,
  }) {
    return MealTrackUiState(
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      selectedPlan: selectedPlan ?? this.selectedPlan,
    );
  }

  @override
  List<Object?> get props => [selectedDayIndex, selectedPlan];
}

class MealTrackUiCubit extends Cubit<MealTrackUiState> {
  MealTrackUiCubit() : super(MealTrackUiState(selectedDayIndex: DateTime.now().weekday % 7));

  void selectDay(int index) {
    emit(state.copyWith(selectedDayIndex: index));
  }

  void selectPlan(MealPlan plan) {
    emit(state.copyWith(selectedPlan: plan));
  }
}
