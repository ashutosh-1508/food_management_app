import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_management_app/presentation/screens/menu_screen.dart';
import '../../state/bloc/meal_plan/meal_plan_bloc.dart';
import '../../state/bloc/navigation/navigation_bloc.dart';
import '../../state/bloc/navigation/navigation_event.dart';
import '../widgets/plan_card.dart';

class MealPlanListScreen extends StatelessWidget {
  const MealPlanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealPlanBloc, MealPlanState>(
      builder: (context, state) {
        if (state is MealPlanLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MealPlanLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.plans.length,
            itemBuilder: (context, index) {
              final plan = state.plans[index];
              final mealTypes = plan.meals.map((e) => e.type.isEmpty ? '' : '${e.type[0].toUpperCase()}${e.type.substring(1)}').toList();
              return PlanCard(
                title: plan.name,
                amount: plan.amount,
                mealTypes: mealTypes,
                frequency: plan.frequency,
                onTap: () {
                   context.read<NavigationBloc>().add(ChangeTab(1, selectedPlan: plan));
                },
              );
            },
          );
        } else if (state is MealPlanError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox();
      },
    );
  }
}
