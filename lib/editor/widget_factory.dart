
import 'package:flutter/material.dart';

/// Створює реальний віджет Flutter на основі його імені.
/// Це центральна "фабрика" для створення нових віджетів з палітри.
Widget createWidgetFromName(String name) {
  switch (name) {
    case 'Container':
      // Тепер контейнер не має фіксованого розміру
      return Container(
        decoration: BoxDecoration(
          color: Colors.blue[100], 
          border: Border.all(color: Colors.blue[800]!),
        ),
        child: const Center(child: Text('Container')),
      );
    case 'Text':
      return const Text('Новий текстовий віджет', style: TextStyle(fontSize: 16));
    case 'Column':
      return const Column(
        mainAxisSize: MainAxisSize.min, // Щоб колонка не розтягувалася
        children: [Text('Елемент 1'), SizedBox(height: 8), Text('Елемент 2')],
      );
    case 'Row':
      return const Row(
         mainAxisSize: MainAxisSize.min, // Щоб ряд не розтягувався
        children: [Text('Елемент 1'), SizedBox(width: 8), Text('Елемент 2')],
      );
    case 'Icon':
      return const Icon(Icons.star, size: 50, color: Colors.orange);
    case 'ElevatedButton':
      return ElevatedButton(onPressed: () {}, child: const Text('Кнопка'));
    // Додамо обробку для віджетів, які ще не реалізовані
    case 'Stack':
    case 'ListView':
    case 'Expanded':
    case 'Padding':
    case 'Center':
    case 'SizedBox':
    case 'Card':
    case 'Image.network':
    case 'Image.asset':
    case 'Placeholder':
    case 'TextButton':
    case 'IconButton':
    case 'TextField':
    case 'Switch':
    case 'Checkbox':
    case 'Slider':
        return Text('$name (ще не реалізовано)');
    default:
      // Заглушка за замовчуванням
      return const Placeholder(fallbackWidth: 100, fallbackHeight: 100);
  }
}
