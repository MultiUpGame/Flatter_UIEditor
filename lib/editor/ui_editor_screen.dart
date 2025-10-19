
import 'package:flutter/material.dart';
import 'package:myapp/editor/canvas_widget_data.dart';
import 'package:myapp/editor/widgets/canvas_view.dart';
import 'package:myapp/editor/widgets/palette_category_view.dart';
import 'package:myapp/editor/widgets/properties_inspector.dart';
import 'package:myapp/editor/widgets_palette_data.dart';

class UiEditorScreen extends StatefulWidget {
  const UiEditorScreen({super.key});

  @override
  State<UiEditorScreen> createState() => _UiEditorScreenState();
}

class _UiEditorScreenState extends State<UiEditorScreen> {
  CanvasWidgetData? _selectedWidgetData;

  void _onWidgetSelected(CanvasWidgetData? widgetData) {
    setState(() {
      _selectedWidgetData = widgetData;
    });
  }

  void _onWidgetUpdated(CanvasWidgetData updatedWidgetData) {
    setState(() {
      _selectedWidgetData = updatedWidgetData;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: CanvasView(
                          onWidgetSelected: _onWidgetSelected,
                          selectedWidgetData: _selectedWidgetData,
                        ),
                      ),
                      const Divider(height: 1),
                      Container(height: 100, color: Colors.black87, child: const Center(child: Text('Рядок стану / Консоль', style: TextStyle(color: Colors.white70)))),
                    ],
                  ),
                ),
                Container(
                  width: 200,
                  color: basePanelColor,
                  child: PropertiesInspector(
                    selectedWidgetData: _selectedWidgetData,
                    onWidgetUpdated: _onWidgetUpdated,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
