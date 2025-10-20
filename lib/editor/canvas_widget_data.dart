import 'package:flutter/material.dart';

class CanvasWidgetData {
  final String id;
  final Widget widget;
  final Offset position;
  final Size? size;
  final Color? color; // Зберігаємо колір для інспектора
  final GlobalKey key;
  final List<CanvasWidgetData> childWidgets; // Список дочірніх віджетів
  final String? parentId;

  CanvasWidgetData({
    required this.id,
    required this.widget,
    required this.position,
    this.size,
    this.color,
    this.parentId,
    List<CanvasWidgetData>? childWidgets,
  })  : key = GlobalKey(),
        childWidgets = childWidgets ?? [];

  /// Створює копію об'єкта з можливістю змінити деякі поля.
  /// Це допомагає уникнути помилок, коли ми втрачаємо дані (наприклад, дочірні віджети).
  CanvasWidgetData copyWith({
    String? id,
    Widget? widget,
    Offset? position,
    Size? size,
    Color? color,
    GlobalKey? key,
    List<CanvasWidgetData>? childWidgets,
    String? parentId,
  }) {
    return CanvasWidgetData(
      id: id ?? this.id,
      widget: widget ?? this.widget,
      position: position ?? this.position,
      size: size ?? this.size,
      color: color ?? this.color,
      childWidgets: childWidgets ?? this.childWidgets,
      parentId: parentId ?? this.parentId,
    );
  }
}
