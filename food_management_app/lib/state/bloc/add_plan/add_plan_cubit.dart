import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPlanState extends Equatable {
  final bool showPriceBreakdown;
  final String? selectedFrequency;
  
  const AddPlanState({
    this.showPriceBreakdown = false,
    this.selectedFrequency,
  });

  AddPlanState copyWith({
    bool? showPriceBreakdown,
    String? selectedFrequency,
  }) {
    return AddPlanState(
      showPriceBreakdown: showPriceBreakdown ?? this.showPriceBreakdown,
      selectedFrequency: selectedFrequency ?? this.selectedFrequency,
    );
  }

  @override
  List<Object?> get props => [showPriceBreakdown, selectedFrequency];
}

class AddPlanCubit extends Cubit<AddPlanState> {
  AddPlanCubit() : super(const AddPlanState());

  void togglePriceBreakdown(bool value) {
    emit(state.copyWith(showPriceBreakdown: value));
  }

  void selectFrequency(String? value) {
    emit(state.copyWith(selectedFrequency: value));
  }
}
