import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/meal_plan.dart';

class MealPlanRepository {
  Future<List<MealPlan>> getMealPlans() async {
    final jsonString = await rootBundle.loadString('lib/data/mock/meal_plans.json');
    final jsonData = json.decode(jsonString);
    
    return (jsonData['mealPlans'] as List)
        .map((json) => MealPlan.fromJson(json))
        .toList();
  }

  Future<MealPlan?> getTodaysMealPlan() async {
    final plans = await getMealPlans();
    return plans.firstWhere((plan) => plan.isActive == 'true', orElse: () => plans.first);
  }
}