
import 'package:flutter/material.dart';

// Модель для віджета на полотні
class CanvasWidgetData {
  final String id; // Унікальний ID
  final Widget widget; // Сам віджет
  Offset position; // Позиція на полотні
  final GlobalKey key; // Ключ для отримання розміру

  CanvasWidgetData({
    required this.id, 
    required this.widget, 
    required this.position, 
    required this.key
  });
}
