import 'package:flutter/material.dart';
import 'package:myapp/editor/palette/widgets_palette_data.dart';
import 'package:myapp/editor/widget_factory.dart';

class PaletteItemCard extends StatelessWidget {
  final PaletteItem item;

  const PaletteItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final widgetFactory = WidgetFactory();
    return Draggable<PaletteItem>(
        data: item,
        feedback: Material(
          color: Colors.transparent,
          child: widgetFactory.createWidgetFromName(item.name),
        ),
        child: InkWell(
          onTap: () {},
          child: SizedBox(
            height: 24,
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
