
import 'package:flutter/material.dart';
import 'package:myapp/editor/widgets/canvas_view.dart';
import 'package:myapp/editor/widgets/palette_category_view.dart';
import 'package:myapp/editor/widgets_palette_data.dart';

// Тепер це знову може бути простий StatelessWidget
class UiEditorScreen extends StatelessWidget {
  const UiEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Групуємо віджети для палітри. Ця логіка залишається тут,
    // оскільки вона специфічна для побудови палітри.
    final Map<String, List<PaletteItem>> groupedWidgets = {};
    for (var item in widgetsPalette) {
      if (!groupedWidgets.containsKey(item.category)) {
        groupedWidgets[item.category] = [];
      }
      groupedWidgets[item.category]!.add(item);
    }

    final Color basePanelColor = Colors.grey[200]!;

    return Scaffold(
      body: Column(
        children: [
          Container(height: 30, color: Colors.blueGrey[100], child: const Center(child: Text('Панель інструментів'))),
          const Divider(height: 1),
          Expanded(
            child: Row(
              children: [
                // Ліва колонка (Палітра та Дерево)
                Container(
                  width: 200,
                  color: basePanelColor,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                          child: ListView.builder(
                            itemCount: groupedWidgets.keys.length,
                            itemBuilder: (context, index) {
                              String categoryName = groupedWidgets.keys.elementAt(index);
                              List<PaletteItem> items = groupedWidgets[categoryName]!;
                              return PaletteCategoryView(categoryName: categoryName, items: items);
                            },
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(flex: 3, child: Container(padding: const EdgeInsets.all(8.0), color: Colors.grey[300], child: const Center(child: Text('Дерево віджетів')))),
                    ],
                  ),
                ),

                // Центральна колонка (Полотно та Консоль)
                Expanded(
                  child: Column(
                    children: [
                      // Ось і все! Замість купи коду - один віджет.
                      const Expanded(child: CanvasView()),
                      const Divider(height: 1),
                      Container(height: 100, color: Colors.black87, child: const Center(child: Text('Рядок стану / Консоль', style: TextStyle(color: Colors.white70)))),
                    ],
                  ),
                ),

                // Права панель (Інспектор властивостей)
                Container(width: 200, color: basePanelColor, padding: const EdgeInsets.all(8.0), child: const Center(child: Text('Інспектор властивостей'))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
