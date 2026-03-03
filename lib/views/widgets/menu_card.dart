import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/daily_menu.dart';

/// A beautifully styled card displaying a single food item
/// with rounded corners, elevation, and category-appropriate icon.
class MenuCard extends StatelessWidget {
  final FoodItem item;
  final int index;

  const MenuCard({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _categoryColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_categoryIcon, color: _categoryColor, size: 22),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          _categoryLabel,
          style: TextStyle(
            fontSize: 12,
            color: _categoryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: item.calories != null
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.crimson.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${item.calories} kcal',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: AppColors.crimsonDark,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  IconData get _categoryIcon {
    switch (item.category) {
      case FoodCategory.soup:
        return Icons.soup_kitchen;
      case FoodCategory.main:
        return Icons.restaurant;
      case FoodCategory.side:
        return Icons.rice_bowl;
      case FoodCategory.dessert:
        return Icons.cake;
      case FoodCategory.other:
        return Icons.lunch_dining;
    }
  }

  Color get _categoryColor {
    switch (item.category) {
      case FoodCategory.soup:
        return const Color(0xFFE67E22);
      case FoodCategory.main:
        return AppColors.crimson;
      case FoodCategory.side:
        return AppColors.info;
      case FoodCategory.dessert:
        return const Color(0xFF8E44AD);
      case FoodCategory.other:
        return AppColors.navyDark;
    }
  }

  String get _categoryLabel {
    switch (item.category) {
      case FoodCategory.soup:
        return 'Çorba';
      case FoodCategory.main:
        return 'Ana Yemek';
      case FoodCategory.side:
        return 'Yardımcı Yemek';
      case FoodCategory.dessert:
        return 'Tatlı';
      case FoodCategory.other:
        return 'Diğer';
    }
  }
}
