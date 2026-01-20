import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealTrackUiState extends Equatable {
  final int selectedDayIndex;

  const MealTrackUiState({
    required this.selectedDayIndex,
  });

  MealTrackUiState copyWith({
    int? selectedDayIndex,
  }) {
    return MealTrackUiState(
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
    );
  }

  @override
  List<Object?> get props => [selectedDayIndex];
}

class MealTrackUiCubit extends Cubit<MealTrackUiState> {
  MealTrackUiCubit() : super(MealTrackUiState(selectedDayIndex: DateTime.now().weekday % 7));

  void selectDay(int index) {
    emit(state.copyWith(selectedDayIndex: index));
  }
}
