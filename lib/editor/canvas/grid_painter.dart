import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final double gridSize;

  GridPainter({this.gridSize = 10.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]! // Колір ліній сітки
      ..strokeWidth = 0.5;

    // Малюємо вертикальні лінії
    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Малюємо горизонтальні лінії
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Сітка не змінюється, тому перемальовувати не потрібно
  }
}
