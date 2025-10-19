
import 'package:flutter/material.dart';
import 'package:myapp/editor/canvas_widget_data.dart';

// Віджет, який можна перетягувати та виділяти
class DraggableItem extends StatelessWidget {
  final CanvasWidgetData widgetData;
  final bool isSelected;
  final VoidCallback onTap;
  final Function(Offset) onDragEnd;

  const DraggableItem({
    super.key,
    required this.widgetData,
    required this.isSelected,
    required this.onTap,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    final width = widgetData.size?.width;
    final height = widgetData.size?.height;

    return Positioned(
      left: widgetData.position.dx,
      top: widgetData.position.dy,
      child: Draggable<CanvasWidgetData>(
        data: widgetData,
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: width,
            height: height,
            child: widgetData.widget,
          ),
        ),
        childWhenDragging: Container(),
        onDragEnd: (details) {
          onDragEnd(details.offset);
        },
        // Основний вигляд віджета
        child: GestureDetector(
          onTap: onTap, // Обробляємо клік для виділення
          child: Stack(
            children: [
              // 1. Сам віджет у контейнері з розмірами
              Container(
                key: widgetData.key,
                width: width,
                height: height,
                child: widgetData.widget,
              ),
              // 2. Рамка, що накладається поверх, якщо віджет виділено
              if (isSelected)
                Positioned.fill(
                  child: IgnorePointer( // Робимо рамку "прозорою" для кліків
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
