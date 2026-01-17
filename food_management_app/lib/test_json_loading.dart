// lib/test_json_loading.dart
import 'dart:convert';
import 'package:flutter/services.dart';

Future<void> testJsonLoading() async {
  try {
    // Load the JSON file
    final String jsonString = await rootBundle.loadString(
      'lib/data/mock/meal_plans.json',
    );
    
    // Parse the JSON
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    
    // Print to verify
    print('✅ JSON loaded successfully!');
    print('Total Meal Plans: ${jsonData['mealPlans'].length}');
    print('Total Attendance Records: ${jsonData['attendance'].length}');
    print('Total Feedback: ${jsonData['feedback'].length}');
    
    // Print first meal plan
    if (jsonData['mealPlans'].isNotEmpty) {
      final firstPlan = jsonData['mealPlans'][0];
      print('\n📋 First Meal Plan:');
      print('Name: ${firstPlan['name']}');
      print('Amount: ₹${firstPlan['amount']}');
      print('Frequency: ${firstPlan['frequency']}');
      print('Number of Meals: ${firstPlan['meals'].length}');
    }
  } catch (e) {
    print('❌ Error loading JSON: $e');
  }
}