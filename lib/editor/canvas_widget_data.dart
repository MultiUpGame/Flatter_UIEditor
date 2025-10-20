import 'package:flutter/material.dart';

class CanvasWidgetData {
  final String id;
  final Widget widget;
  final Offset position;
  final Size? size;
  final Color? color;
  final GlobalKey key;
  final List<CanvasWidgetData> children;

  CanvasWidgetData({
    required this.id,
    required this.widget,
    required this.position,
    this.size,
    this.color,
    required this.key,
    this.children = const [],
  });
}
