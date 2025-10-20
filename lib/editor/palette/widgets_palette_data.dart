
import 'package:flutter/material.dart';

// Клас для представлення одного елемента в нашій палітрі
class PaletteItem {
  final String name;       // Назва віджета, яку бачить користувач
  final IconData icon;     // Іконка для візуального представлення
  final String category;   // Категорія, до якої належить віджет

  const PaletteItem({
    required this.name,
    required this.icon,
    required this.category,
  });
}

// Основний, підібраний список віджетів для нашої палітри.
// Це наша "база даних" віджетів.
final List<PaletteItem> widgetsPalette = [
  // --- Категорія: Макет (Layout) ---
  const PaletteItem(name: 'Container', icon: Icons.check_box_outline_blank, category: 'Макет'),
  const PaletteItem(name: 'Column', icon: Icons.view_column_sharp, category: 'Макет'),
  const PaletteItem(name: 'Row', icon: Icons.view_week_sharp, category: 'Макет'),
  const PaletteItem(name: 'Stack', icon: Icons.layers, category: 'Макет'),
  const PaletteItem(name: 'ListView', icon: Icons.list, category: 'Макет'),
  const PaletteItem(name: 'Expanded', icon: Icons.open_in_full, category: 'Макет'),
  const PaletteItem(name: 'Padding', icon: Icons.padding, category: 'Макет'),
  const PaletteItem(name: 'Center', icon: Icons.align_horizontal_center, category: 'Макет'),
  const PaletteItem(name: 'SizedBox', icon: Icons.space_bar, category: 'Макет'),
  const PaletteItem(name: 'Card', icon: Icons.credit_card, category: 'Макет'),

  // --- Категорія: Базові елементи (Basics) ---
  const PaletteItem(name: 'Text', icon: Icons.text_fields, category: 'Базові елементи'),
  const PaletteItem(name: 'Icon', icon: Icons.insert_emoticon, category: 'Базові елементи'),
  const PaletteItem(name: 'Image.network', icon: Icons.http, category: 'Базові елементи'),
  const PaletteItem(name: 'Image.asset', icon: Icons.image, category: 'Базові елементи'),
  const PaletteItem(name: 'Placeholder', icon: Icons.disabled_by_default, category: 'Базові елементи'),

  // --- Категорія: Кнопки та Поля вводу (Input & Buttons) ---
  const PaletteItem(name: 'ElevatedButton', icon: Icons.smart_button, category: 'Кнопки та Поля вводу'),
  const PaletteItem(name: 'TextButton', icon: Icons.text_format, category: 'Кнопки та Поля вводу'),
  const PaletteItem(name: 'IconButton', icon: Icons.mouse, category: 'Кнопки та Поля вводу'),
  const PaletteItem(name: 'TextField', icon: Icons.edit_note, category: 'Кнопки та Поля вводу'),
  const PaletteItem(name: 'Switch', icon: Icons.switch_left, category: 'Кнопки та Поля вводу'),
  const PaletteItem(name: 'Checkbox', icon: Icons.check_box, category: 'Кнопки та Поля вводу'),
  const PaletteItem(name: 'Slider', icon: Icons.linear_scale, category: 'Кнопки та Поля вводу'),
];
