import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_management_app/state/bloc/meal_checkbox_bloc.dart';

sealed class FrequencyDropdownEvent {}

class MonthlyFrequency extends FrequencyDropdownEvent {}

class WeeklyFrequency extends FrequencyDropdownEvent {}

class YearlyFrequency extends FrequencyDropdownEvent {}

class FrequencyState {
  final bool isWeekly;
  final bool isMontly;
  final bool isYearly;

  const FrequencyState({
    required this.isWeekly,
    required this.isMontly,
    required this.isYearly,
  });

  FrequencyState copyWith({bool? isWeekly, bool? isMontly, bool? isYearly}) {
    return FrequencyState(
      isWeekly: isWeekly ?? this.isWeekly,
      isMontly: isMontly ?? this.isMontly,
      isYearly: isYearly ?? this.isYearly,
    );
  }
}

class FrequencyDropdownBloc
    extends Bloc<FrequencyDropdownEvent, FrequencyState> {


  FrequencyDropdownBloc()
    : super(FrequencyState(isWeekly: false, isMontly: false, isYearly: false)) {
    on<WeeklyFrequency>((FrequencyDropdownEvent, emit) {
      emit(state.copyWith(isWeekly: !state.isWeekly));
    });
    on<MonthlyFrequency>((FrequencyDropdownEvent, emit) {
      emit(state.copyWith(isMontly: !state.isMontly));
    });
    on<YearlyFrequency>((FrequencyDropdownEvent, emit) {
      emit(state.copyWith(isYearly: !state.isYearly));
    });
  }
}
