import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_plan_screen.dart';
import '../widgets/top_tab_toggle.dart';
import 'meal_plan_list_screen.dart';
import 'menu_screen.dart';
import 'meal_track_screen.dart';
import 'feedback_screen.dart';
import '../../state/bloc/theme/theme_cubit.dart';
import '../../state/bloc/navigation/navigation_bloc.dart';
import '../../state/bloc/navigation/navigation_state.dart';
import '../../state/bloc/navigation/navigation_event.dart';

class FoodManagementScreen extends StatelessWidget {
  const FoodManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine current theme mode for icon
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, navState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Food Management'),
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
              if (navState.selectedTab == 0)
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddPlanScreen()),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.lightBlue),
                  label: const Text('Add Plan', style: TextStyle(color: Colors.lightBlue)),
                )
            ],
          ),
          body: Column(
            children: [
              TopTabToggle(
                selectedIndex: navState.selectedTab,
                onChanged: (index) {
                  context.read<NavigationBloc>().add(ChangeTab(index));
                },
              ),
              const SizedBox(height: 12),
              Expanded(child: _buildTabContent(navState)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabContent(NavigationState state) {
    switch (state.selectedTab) {
      case 0:
        return const MealPlanListScreen();
      case 1:
        return MenuScreen(plan: state.selectedPlan);
      case 2:
        return const MealTrackScreen();
      case 3:
        return const FeedbackScreen();
      default:
        return const SizedBox();
    }
  }
}
