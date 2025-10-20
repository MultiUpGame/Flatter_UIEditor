import 'package:flutter/material.dart';

/// Створює реальний віджет Flutter на основі його імені.
/// Це центральна "фабрика" для створення нових віджетів з палітри.
class WidgetFactory {
  Widget createWidgetFromName(String name) {
    switch (name) {
      case 'Container':
        // ВИПРАВЛЕНО: Container тепер порожній. Розмір і вигляд контролюються CanvasWidgetData та PropertiesInspector.
        return Container(
          decoration: BoxDecoration(
            color: Colors.blue[100],
            border: Border.all(color: Colors.blue[800]!),
          ),
        );
      case 'Text':
        return const Text('Новий текст', style: TextStyle(fontSize: 16));
      case 'Column':
        // ВИПРАВЛЕНО: Column створюється порожнім.
        return const Column(
          mainAxisSize: MainAxisSize.min,
        );
      case 'Row':
        // ВИПРАВЛЕНО: Row створюється порожнім.
        return const Row(
          mainAxisSize: MainAxisSize.min,
        );
      case 'ElevatedButton':
        return ElevatedButton(
          onPressed: () {},
          child: const Text('Кнопка'),
        );
      default:
        return const Placeholder();
    }
  }
}
