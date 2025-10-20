import 'package:flutter/material.dart';

// Універсальний віджет для перетягування будь-якого вмісту (child)
class DraggableItem extends StatelessWidget {
  final Offset position;
  final VoidCallback onTap;
  final Function(Offset) onDragEnd;
  final Widget child;
  final double scale;

  const DraggableItem({
    super.key,
    required this.position,
    required this.onTap,
    required this.onDragEnd,
    required this.child,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable<String>( // Тепер передаємо просто String (id) 
        // як дані для перетягування
        data: key.toString(), // Використовуємо ключ як унікальний ідентифікатор
        feedback: Material(
          color: Colors.transparent,
          child: child,
        ),
        childWhenDragging: Container(),
        onDragEnd: (details) {
          onDragEnd(details.offset);
        },
        child: GestureDetector(
          onTap: onTap, // Обробка кліку для виділення
          child: child, // Відображаємо переданий дочірній віджет
        ),
      ),
    );
  }
}
