import 'package:flutter/material.dart';
import 'package:myapp/editor/canvas_controller.dart';
import 'package:myapp/editor/canvas_widget_data.dart';
import 'package:myapp/editor/palette/palette_category_view.dart';
import 'package:myapp/editor/palette/widgets_palette_data.dart';
import 'package:myapp/editor/properties/properties_inspector.dart';
import 'package:myapp/editor/tree/widget_tree_view.dart';
import 'package:myapp/editor/widgets/canvas_view.dart';

class UiEditorScreen extends StatefulWidget {
  const UiEditorScreen({super.key});

  @override
  State<UiEditorScreen> createState() => _UiEditorScreenState();
}

class _UiEditorScreenState extends State<UiEditorScreen> {
  late final CanvasController _canvasController;

  @override
  void initState() {
    super.initState();
    _canvasController = CanvasController();
  }

  @override
  void dispose() {
    _canvasController.dispose();
    super.dispose();
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
          Container(
              height: 30,
              color: Colors.blueGrey[100],
              child: const Center(child: Text('Панель інструментів'))),
          const Divider(height: 1),
          Expanded(
            child: Row(
              children: [
                // Ліва панель: Палітра та Дерево віджетів
                Container(
                  width: 200,
                  color: basePanelColor,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 4.0),
                          child: ListView.builder(
                            itemCount: groupedWidgets.keys.length,
                            itemBuilder: (context, index) {
                              String categoryName =
                                  groupedWidgets.keys.elementAt(index);
                              List<PaletteItem> items =
                                  groupedWidgets[categoryName]!;
                              return PaletteCategoryView(
                                  categoryName: categoryName, items: items);
                            },
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        flex: 3,
                        // Використовуємо ValueListenableBuilder для дерева
                        child: ValueListenableBuilder<List<CanvasWidgetData>>(
                          valueListenable:
                              _canvasController.canvasWidgetsNotifier,
                          builder: (context, widgets, child) {
                            return ValueListenableBuilder<CanvasWidgetData?>(
                              valueListenable: _canvasController
                                  .selectedWidgetDataNotifier,
                              builder: (context, selectedWidget, child) {
                                return WidgetTreeView(
                                  widgets: widgets,
                                  selectedId: selectedWidget?.id,
                                  onSelected: (id) {
                                    final selected = _canvasController
                                        .findWidgetById(widgets, id);
                                    _canvasController
                                        .onWidgetSelected(selected);
                                  },
                                  onWidgetMoved:
                                      _canvasController.handleWidgetMove,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Центральна частина: Полотно
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        // Аналогічно для CanvasView
                        child: ValueListenableBuilder<List<CanvasWidgetData>>(
                          valueListenable:
                              _canvasController.canvasWidgetsNotifier,
                          builder: (context, widgets, child) {
                            return ValueListenableBuilder<CanvasWidgetData?>(
                              valueListenable: _canvasController
                                  .selectedWidgetDataNotifier,
                              builder: (context, selectedWidget, child) {
                                return CanvasView(
                                  onWidgetSelected:
                                      _canvasController.onWidgetSelected,
                                  selectedWidgetData: selectedWidget,
                                  canvasWidgets: widgets,
                                  onWidgetsUpdated:
                                      _canvasController.onWidgetsUpdated,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      Container(
                          height: 100,
                          color: Colors.black87,
                          child: const Center(
                              child: Text('Рядок стану / Консоль',
                                  style: TextStyle(color: Colors.white70)))),
                    ],
                  ),
                ),
                // Права панель: Інспектор властивостей
                Container(
                  width: 200,
                  color: basePanelColor,
                  // І для PropertiesInspector
                  child: ValueListenableBuilder<CanvasWidgetData?>(
                    valueListenable:
                        _canvasController.selectedWidgetDataNotifier,
                    builder: (context, selectedWidget, child) {
                      return PropertiesInspector(
                        selectedWidgetData: selectedWidget,
                        onWidgetUpdated: _canvasController.onWidgetUpdated,
                        onWidgetDeleted: _canvasController.onWidgetDeleted,
                      );
                    },
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
