
import 'package:flutter/material.dart';

class CanvasWidgetData {
  final String id;
  final Widget widget;
  Offset position;
  Size? size;
  Color? color;
  final GlobalKey key;

  CanvasWidgetData({
    required this.id,
    required this.widget,
    required this.position,
    this.size,
    this.color,
    required this.key,
  });
}
