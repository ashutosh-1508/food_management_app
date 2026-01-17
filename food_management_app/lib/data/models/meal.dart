class MealPlan {
  final String id;
  final String type;
  final String startTime;
  final String endTime;
  final String items;

  MealPlan({
    required this.id,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.items,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      type: json['type'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      items: json['items'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      startTime: "startTime",
      endTime: 'endTime',
      items: 'items',
    };
  }
}
