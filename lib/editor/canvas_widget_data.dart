
import 'package:flutter/material.dart';

class CanvasWidgetData {
  final String id;
  final Widget widget;
  Offset position;
  Size? size; // Додано поле для розміру
  final GlobalKey key;

  CanvasWidgetData({
    required this.id,
    required this.widget,
    required this.position,
    this.size, // Додано в конструктор
    required this.key,
  });
}
