import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_management_app/presentation/screens/add_plan_screen.dart';
import 'package:food_management_app/presentation/screens/food_management_screen.dart';
import 'package:food_management_app/state/bloc/meal_checkbox_bloc.dart';

import 'package:food_management_app/test_json_loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Test JSON loading
  await testJsonLoading();

  runApp(FoodApp());
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => MealCheckboxBloc())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const FoodManagementScreen(),
      ),
    );
  }
}
