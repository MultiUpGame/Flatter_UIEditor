
import 'package:flutter/material.dart';
import 'package:myapp/editor/widget_factory.dart';
import 'package:myapp/editor/widgets_palette_data.dart';

// Віджет, що відповідає за полотно та його логіку (drag-and-drop)
class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  // Список віджетів, що знаходяться на полотні
  final List<Widget> _canvasWidgets = [];

  @override
  Widget build(BuildContext context) {
    return DragTarget<PaletteItem>(
      // Функція, що вирішує, чи приймати віджет
      onWillAccept: (data) => true,
      // Функція, що викликається, коли віджет "кинули"
      onAccept: (data) {
        setState(() {
          // Використовуємо нашу нову фабрику для створення віджета
          _canvasWidgets.add(createWidgetFromName(data.name));
        });
      },
      // Будівельник, що малює область
      builder: (context, candidateData, rejectedData) {
        // Підсвічуємо область, коли над нею є віджет для перетягування
        bool isHovered = candidateData.isNotEmpty;

        return Container(
          color: isHovered ? Colors.lightGreen[100] : Colors.white,
          // Використовуємо Stack, щоб розміщувати віджети один над одним
          child: Stack(
            // Поки що просто центруємо всі віджети
            children: _canvasWidgets.map((widget) => Center(child: widget)).toList(),
          ),
        );
      },
    );
  }
}
