
import 'package:flutter/material.dart';
import 'package:myapp/editor/widgets/palette_item_card.dart';
import 'package:myapp/editor/widgets_palette_data.dart';

// Віджет для однієї категорії в палітрі
class PaletteCategoryView extends StatelessWidget {
  final String categoryName;
  final List<PaletteItem> items;

  const PaletteCategoryView({super.key, required this.categoryName, required this.items});

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Colors.grey[50]!;
    final Color expandedListColor = Colors.grey[100]!;

    // Контейнер, що створює ефект "картки" з тінню
    return Container(
      margin: const EdgeInsets.only(bottom: 4.0), // Відступ між картками
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ExpansionTile(
        // Фон для розкритого списку
        backgroundColor: expandedListColor,
        minTileHeight: 28,
        tilePadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
        title: Text(
          categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.only(left: 12.0),
        // Використовуємо наш новий віджет PaletteItemCard
        children: items.map((item) => PaletteItemCard(item: item)).toList(),
      ),
    );
  }
}
