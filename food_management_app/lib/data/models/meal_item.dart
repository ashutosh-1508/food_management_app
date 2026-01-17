class MealItem {
  final String diet;
  final String name;

  MealItem({required this.diet, required this.name});

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      diet: json['diet'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diet': diet,
      'name': name,
    };
  }
}