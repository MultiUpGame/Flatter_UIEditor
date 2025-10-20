import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final double gridSize;
  final TransformationController controller;

  GridPainter({
    this.gridSize = 20.0,
    required this.controller,
  }) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = controller.value.getMaxScaleOnAxis();
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5 / scale; // Зберігаємо товщину лінії постійною

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
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.gridSize != gridSize || oldDelegate.controller != controller;
  }
}
