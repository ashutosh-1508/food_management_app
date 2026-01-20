import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_management_app/presentation/screens/add_plan_screen.dart';
import 'package:food_management_app/presentation/screens/food_management_screen.dart';
import 'package:food_management_app/state/bloc/meal_checkbox_bloc.dart';
import 'package:food_management_app/state/bloc/meal_plan/meal_plan_bloc.dart';
import 'package:food_management_app/state/bloc/menu/menu_bloc.dart';
import 'package:food_management_app/state/bloc/attendance/attendance_bloc.dart';
import 'package:food_management_app/state/bloc/feedback/feedback_bloc.dart';
import 'package:food_management_app/data/repositories/food_repository.dart';

import 'package:food_management_app/state/bloc/theme/theme_cubit.dart';
import 'package:food_management_app/state/bloc/navigation/navigation_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FoodApp());
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FoodRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                MealPlanBloc(repository: context.read<FoodRepository>())
                  ..add(LoadMealPlans()),
          ),
          BlocProvider(
            create: (context) =>
                MenuBloc(repository: context.read<FoodRepository>())
                  ..add(LoadMenu()),
          ),
          BlocProvider(
            create: (context) =>
                AttendanceBloc(repository: context.read<FoodRepository>())
                  ..add(LoadAttendance()),
          ),
          BlocProvider(
            create: (context) =>
                FeedbackBloc(repository: context.read<FoodRepository>())
                  ..add(LoadFeedback()),
          ),
          BlocProvider(create: (context) => MealCheckboxBloc()),
          BlocProvider(create: (context) => ThemeCubit()),
          BlocProvider(create: (context) => NavigationBloc()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: ThemeData.light().copyWith(
                scaffoldBackgroundColor: const Color(0xFFF5F5F5),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black, // Dark text for light mode
                  elevation: 0,
                ),
                cardColor: Colors.white,
                colorScheme: const ColorScheme.light(
                  primary: Colors.blue,
                  secondary: Colors.lightBlueAccent,
                ),
              ),
              darkTheme: ThemeData.dark().copyWith(
                scaffoldBackgroundColor: const Color.fromRGBO(38, 40, 50, 1),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color.fromRGBO(38, 40, 50, 1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                cardColor: const Color(0xFF2F3344),
                colorScheme: const ColorScheme.dark(
                  primary: Colors.blue,
                  secondary: Colors.lightBlueAccent,
                ),
              ),
              home: const FoodManagementScreen(),
            );
          },
        ),
      ),
    );
  }
}
