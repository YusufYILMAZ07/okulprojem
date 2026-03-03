/// Single food item (Çorba, Ana Yemek, Yardımcı Yemek, Tatlı, etc.)
class FoodItem {
  final String name;
  final int? calories;
  final FoodCategory category;

  const FoodItem({
    required this.name,
    this.calories,
    this.category = FoodCategory.other,
  });

  int get effectiveCalories => calories ?? 0;

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] as String? ?? '',
      calories: json['calories'] as int?,
      category: FoodCategory.fromString(json['category'] as String?),
    );
  }
}

/// Category of the food item for icon & color mapping.
enum FoodCategory {
  soup, // Çorba
  main, // Ana Yemek
  side, // Yardımcı Yemek
  dessert, // Tatlı
  other;

  static FoodCategory fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'soup':
      case 'çorba':
        return FoodCategory.soup;
      case 'main':
      case 'ana yemek':
        return FoodCategory.main;
      case 'side':
      case 'yardımcı':
        return FoodCategory.side;
      case 'dessert':
      case 'tatlı':
        return FoodCategory.dessert;
      default:
        return FoodCategory.other;
    }
  }
}

/// Daily meal plan containing all food items for a specific date.
class DailyMenu {
  final DateTime date;
  final List<FoodItem> items;

  const DailyMenu({required this.date, required this.items});

  int get totalCalories =>
      items.fold(0, (sum, item) => sum + item.effectiveCalories);

  factory DailyMenu.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['date'] as String);
    final items = (json['items'] as List<dynamic>)
        .map((i) => FoodItem.fromJson(i as Map<String, dynamic>))
        .toList();
    return DailyMenu(date: date, items: items);
  }
}
