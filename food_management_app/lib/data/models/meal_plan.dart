class MealPlan {
  final String id;
  final String name;
  final String frequency;
  final String amount;
  final String isActive;
  final String meals;

  MealPlan({
    required this.id,
    required this.name,
    required this.amount,
    required this.frequency,
    required this.isActive,
    required this.meals,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      frequency: json['frequency'],
      isActive: json['isActive'],
      meals: json['meals'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name,amount:"amount",frequency:'frequency',isActive:'isActive',meals:'meals'};
  }
}
