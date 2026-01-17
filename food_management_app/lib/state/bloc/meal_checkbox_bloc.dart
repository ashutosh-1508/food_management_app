import 'package:flutter_bloc/flutter_bloc.dart';

sealed class CheckBoxEvent {}

class IsBreakfastCheck extends CheckBoxEvent {}

class IsLunchCheck extends CheckBoxEvent {}

class IsSnacksCheck extends CheckBoxEvent {}

class IsDinnerCheck extends CheckBoxEvent {}

class MealCheckboxState {
  final bool isBreakfast;
  final bool isLunch;
  final bool isSnacks;
  final bool isDinner;

  const MealCheckboxState({
    required this.isBreakfast,
    required this.isLunch,
    required this.isSnacks,
    required this.isDinner,
  });

  MealCheckboxState copyWith({
    bool? isBreakfast,
    bool? isLunch,
    bool? isSnacks,
    bool? isDinner,
  }) {
    return MealCheckboxState(
      isBreakfast: isBreakfast ?? this.isBreakfast,
      isLunch: isLunch ?? this.isLunch,
      isSnacks: isSnacks ?? this.isSnacks,
      isDinner: isDinner ?? this.isDinner,
    );
  }
}

class MealCheckboxBloc extends Bloc<CheckBoxEvent, MealCheckboxState> {
  // bool isBreakfastCheck = false;
  // bool isLunchCheck = false;
  // bool isSnacksCheck = false;
  // bool isDinnerCheck = false;

  MealCheckboxBloc()
    : super(
        MealCheckboxState(
          isBreakfast: false,
          isLunch: false,
          isSnacks: false,
          isDinner: false,
        ),
      ) {
    on<IsBreakfastCheck>((CheckBoxEvent, emit) {
      emit(state.copyWith(isBreakfast: !state.isBreakfast));
    });
    on<IsLunchCheck>((CheckBoxEvent, emit) {
      emit(state.copyWith(isLunch: !state.isLunch));
    });
    on<IsSnacksCheck>((CheckBoxEvent, emit) {
      emit(state.copyWith(isSnacks: !state.isSnacks));
    });
    on<IsDinnerCheck>((CheckBoxEvent, emit) {
      emit(state.copyWith(isDinner: !state.isDinner));
    });
  }
}
