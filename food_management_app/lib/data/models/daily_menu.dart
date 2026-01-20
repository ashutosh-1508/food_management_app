class DailyMenuItem {
  final String name;
  final String diet;
  final bool isAvailable;

  DailyMenuItem({
    required this.name,
    required this.diet,
    required this.isAvailable,
  });

  factory DailyMenuItem.fromJson(Map<String, dynamic> json) {
    return DailyMenuItem(
      name: json['name'] as String? ?? '',
      diet: json['diet'] as String? ?? 'veg',
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }
}

class DailyMenu {
  final String id;
  final String date;
  final String mealType;
  final List<DailyMenuItem> items;

  DailyMenu({
    required this.id,
    required this.date,
    required this.mealType,
    required this.items,
  });

  factory DailyMenu.fromJson(Map<String, dynamic> json) {
    return DailyMenu(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      mealType: json['mealType'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => DailyMenuItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
