class MealItem {
  final String id;
  final String diet;
  final String name;
  final String description;

  MealItem({
    required this.id,
    required this.diet,
    required this.name,
    required this.description,
  });

  MealItem copyWith({
    String? id,
    String? diet,
    String? name,
    String? description,
  }) {
    return MealItem(
      id: id ?? this.id,
      diet: diet ?? this.diet,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      id: json['id'] as String? ?? '',
      diet: json['diet'] as String? ?? 'veg',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'diet': diet,
      'name': name,
      'description': description,
    };
  }
}