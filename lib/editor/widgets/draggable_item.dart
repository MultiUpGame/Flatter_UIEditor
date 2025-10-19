
import 'package:flutter/material.dart';
import 'package:myapp/editor/canvas_widget_data.dart';

// Віджет, який можна перетягувати в межах полотна
class DraggableItem extends StatelessWidget {
  final CanvasWidgetData widgetData;
  final Function(Offset) onDragEnd;

  const DraggableItem({
    super.key,
    required this.widgetData,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widgetData.position.dx,
      top: widgetData.position.dy,
      child: Draggable<CanvasWidgetData>(
        data: widgetData,
        // Віджет, який ви бачите, коли тягнете
        feedback: Material(
          color: Colors.transparent,
          child: widgetData.widget,
        ),
        // Віджет, що залишається на старому місці (нічого)
        childWhenDragging: Container(),
        // Коли перетягування завершено
        onDragEnd: (details) {
          onDragEnd(details.offset);
        },
        // Віджет у спокійному стані
        child: Container(
          key: widgetData.key,
          child: widgetData.widget,
        ),
      ),
    );
  }
}
