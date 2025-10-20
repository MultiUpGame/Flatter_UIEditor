import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/editor/canvas_controller.dart';
import 'package:myapp/editor/canvas_widget_data.dart';
import 'package:myapp/editor/palette/palette_category_view.dart';
import 'package:myapp/editor/palette/widgets_palette_data.dart';
import 'package:myapp/editor/properties/properties_inspector.dart';
import 'package:myapp/editor/tree/widget_tree_view.dart';
import 'package:myapp/editor/canvas/canvas_view.dart';
import 'package:myapp/generator/code_generator.dart';

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

  void _showGeneratedCode() {
    final codeGenerator = CodeGenerator();
    final currentWidgets = _canvasController.canvasWidgetsNotifier.value;
    final generatedCode = codeGenerator.generateScreenCode(currentWidgets);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Згенерований Dart-код'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: SingleChildScrollView(
            child: SelectableText(
              generatedCode,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: generatedCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Код скопійовано до буфера обміну!')),
              );
            },
            child: const Text('Копіювати'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрити'),
          ),
        ],
      ),
    );
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
              height: 40,
              color: Colors.blueGrey[100],
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Flutter UI Редактор', style: TextStyle(fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.code, size: 16),
                    label: const Text('Згенерувати код'),
                    onPressed: _showGeneratedCode,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      textStyle: const TextStyle(fontSize: 12),
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )),
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
                                    final selected = _canvasController.findWidgetById(id);
                                    _canvasController.onWidgetSelected(selected);
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
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
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
                Container(
                  width: 200,
                  color: basePanelColor,
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
