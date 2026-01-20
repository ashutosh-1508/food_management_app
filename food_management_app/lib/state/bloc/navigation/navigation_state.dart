import 'package:equatable/equatable.dart';
import '../../../data/models/meal_plan.dart';

class NavigationState extends Equatable {
  final int selectedTab;
  final MealPlan? selectedPlan;

  const NavigationState({
    this.selectedTab = 0,
    this.selectedPlan,
  });

  NavigationState copyWith({
    int? selectedTab,
    MealPlan? selectedPlan,
  }) {
    return NavigationState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedPlan: selectedPlan ?? this.selectedPlan,
    );
  }

  @override
  List<Object?> get props => [selectedTab, selectedPlan];
}
