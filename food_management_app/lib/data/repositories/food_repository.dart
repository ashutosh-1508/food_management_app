import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/meal_plan.dart';
import '../models/attendance.dart';
import '../models/feedback.dart';
import '../models/daily_menu.dart';

class FoodRepository {
  Future<Map<String, dynamic>> _loadJson() async {
    final String response = await rootBundle.loadString('lib/data/mock/meal_plans.json');
    return json.decode(response);
  }

  Future<List<MealPlan>> getMealPlans() async {
    final data = await _loadJson();
    return (data['mealPlans'] as List)
        .map((e) => MealPlan.fromJson(e))
        .toList();
  }

  Future<List<Attendance>> getAttendance() async {
    final data = await _loadJson();
    return (data['attendance'] as List)
        .map((e) => Attendance.fromJson(e))
        .toList();
  }

  Future<List<MealFeedback>> getFeedback() async {
    final data = await _loadJson();
    return (data['feedback'] as List)
        .map((e) => MealFeedback.fromJson(e))
        .toList();
  }

  Future<List<DailyMenu>> getDailyMenus() async {
    final data = await _loadJson();
    return (data['menuItems'] as List)
        .map((e) => DailyMenu.fromJson(e))
        .toList();
  }
}
