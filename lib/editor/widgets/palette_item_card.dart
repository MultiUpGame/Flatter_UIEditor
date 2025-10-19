
import 'package:flutter/material.dart';
import 'package:myapp/editor/widget_factory.dart';
import 'package:myapp/editor/widgets_palette_data.dart';

// Віджет для одного елемента в палітрі
class PaletteItemCard extends StatelessWidget {
  final PaletteItem item;

  const PaletteItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Обгортаємо елемент в Draggable
    return Draggable<PaletteItem>(
      data: item, // Дані, що перетягуються
      // Віджет, який видно під курсором під час перетягування
      feedback: Material(
        color: Colors.transparent,
        child: createWidgetFromName(item.name),
      ),
      // Оригінальний віджет у списку
      child: InkWell(
        onTap: () {
          // Поки що нічого не робимо, але залишаємо для майбутнього
        },
        child: SizedBox(
          height: 24, // Жорстка висота елемента
          child: Row(
            children: [
              Icon(item.icon, size: 15),
              const SizedBox(width: 12),
              Text(
                item.name,
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
