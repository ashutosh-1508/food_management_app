import 'meal_item.dart';

class Meal {
  final String id;
  final String type;
  final String startTime;
  final String endTime;
  final int price;
  final List<MealItem> items;

  Meal({
    required this.id,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.items,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      price: json['price'] as int? ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => MealItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'startTime': startTime,
      'endTime': endTime,
      'price': price,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}
