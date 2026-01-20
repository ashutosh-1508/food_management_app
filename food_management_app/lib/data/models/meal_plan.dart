import 'meal.dart';

class MealPlan {
  final String id;
  final String name;
  final String frequency;
  final int amount;
  final bool isActive;
  final String createdAt;
  final List<Meal> meals;

  MealPlan({
    required this.id,
    required this.name,
    required this.frequency,
    required this.amount,
    required this.isActive,
    required this.createdAt,
    required this.meals,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      frequency: json['frequency'] as String? ?? 'daily',
      amount: json['amount'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
      meals: (json['meals'] as List<dynamic>?)
              ?.map((e) => Meal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'frequency': frequency,
      'amount': amount,
      'isActive': isActive,
      'createdAt': createdAt,
      'meals': meals.map((e) => e.toJson()).toList(),
    };
  }
}
