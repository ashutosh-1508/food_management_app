import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuUiState extends Equatable {
  final int selectedDayIndex;
  final bool isBreakfastExpanded;
  final bool isLunchExpanded;
  final bool isSnacksExpanded;
  final bool isDinnerExpanded;

  const MenuUiState({
    required this.selectedDayIndex,
    this.isBreakfastExpanded = true,
    this.isLunchExpanded = true,
    this.isSnacksExpanded = true,
    this.isDinnerExpanded = true,
  });

  MenuUiState copyWith({
    int? selectedDayIndex,
    bool? isBreakfastExpanded,
    bool? isLunchExpanded,
    bool? isSnacksExpanded,
    bool? isDinnerExpanded,
  }) {
    return MenuUiState(
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      isBreakfastExpanded: isBreakfastExpanded ?? this.isBreakfastExpanded,
      isLunchExpanded: isLunchExpanded ?? this.isLunchExpanded,
      isSnacksExpanded: isSnacksExpanded ?? this.isSnacksExpanded,
      isDinnerExpanded: isDinnerExpanded ?? this.isDinnerExpanded,
    );
  }

  @override
  List<Object?> get props => [
        selectedDayIndex,
        isBreakfastExpanded,
        isLunchExpanded,
        isSnacksExpanded,
        isDinnerExpanded,
      ];
}

class MenuUiCubit extends Cubit<MenuUiState> {
  MenuUiCubit() : super(MenuUiState(selectedDayIndex: DateTime.now().weekday % 7));

  void selectDay(int index) {
    emit(state.copyWith(selectedDayIndex: index));
  }

  void toggleSection(String section) {
    switch (section) {
      case 'breakfast':
        emit(state.copyWith(isBreakfastExpanded: !state.isBreakfastExpanded));
        break;
      case 'lunch':
        emit(state.copyWith(isLunchExpanded: !state.isLunchExpanded));
        break;
      case 'snacks':
        emit(state.copyWith(isSnacksExpanded: !state.isSnacksExpanded));
        break;
      case 'dinner':
        emit(state.copyWith(isDinnerExpanded: !state.isDinnerExpanded));
        break;
    }
  }
}
