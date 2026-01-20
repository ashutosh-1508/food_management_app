import 'package:equatable/equatable.dart';
import '../../../data/models/meal_plan.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class ChangeTab extends NavigationEvent {
  final int tabIndex;
  final MealPlan? selectedPlan;

  const ChangeTab(this.tabIndex, {this.selectedPlan});

  @override
  List<Object?> get props => [tabIndex, selectedPlan];
}
