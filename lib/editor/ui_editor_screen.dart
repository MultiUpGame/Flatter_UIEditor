import 'package:flutter/material.dart';
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
  CanvasWidgetData? _selectedWidgetData;
  List<CanvasWidgetData> _canvasWidgets = [];

  void _onWidgetSelected(CanvasWidgetData? widgetData) {
    setState(() {
      _selectedWidgetData = widgetData;
    });
  }

  void _onWidgetUpdated(CanvasWidgetData updatedWidgetData) {
    setState(() {
      _canvasWidgets = _updateWidgetInTree(_canvasWidgets, updatedWidgetData);
      _selectedWidgetData = updatedWidgetData;
    });
  }

  void _onWidgetsUpdated(List<CanvasWidgetData> updatedWidgets) {
    setState(() {
      _canvasWidgets = updatedWidgets;
    });
  }

  void _onWidgetDeleted(String widgetId) {
    setState(() {
      _canvasWidgets = _removeWidgetFromTree(_canvasWidgets, widgetId);
      if (_selectedWidgetData?.id == widgetId) {
        _selectedWidgetData = null;
      }
    });
  }

  void _handleWidgetMove(String draggedItemId, String targetItemId) {
    setState(() {
      // 1. Знайти віджет, який перетягують
      final draggedWidget = _findWidgetById(_canvasWidgets, draggedItemId);
      if (draggedWidget == null) return;

      // 2. Видалити його з попереднього місця
      _canvasWidgets = _removeWidgetFromTree(_canvasWidgets, draggedItemId);

      // 3. Додати його як дочірній до цільового віджета
      _canvasWidgets = _addWidgetToTarget(_canvasWidgets, draggedWidget, targetItemId);
    });
  }

  // --- Допоміжні функції для маніпулювання деревом віджетів ---

  CanvasWidgetData? _findWidgetById(List<CanvasWidgetData> widgets, String id) {
    for (var widget in widgets) {
      if (widget.id == id) return widget;
      final foundInChildren = _findWidgetById(widget.children, id);
      if (foundInChildren != null) return foundInChildren;
    }
    return null;
  }

  List<CanvasWidgetData> _removeWidgetFromTree(List<CanvasWidgetData> widgets, String id) {
    List<CanvasWidgetData> newWidgets = [];
    for (var widget in widgets) {
      if (widget.id != id) {
        final newChildren = _removeWidgetFromTree(widget.children, id);
        newWidgets.add(CanvasWidgetData(
          id: widget.id,
          widget: widget.widget,
          position: widget.position,
          size: widget.size,
          color: widget.color,
          key: widget.key,
          children: newChildren,
        ));
      }
    }
    return newWidgets;
  }

  List<CanvasWidgetData> _addWidgetToTarget(List<CanvasWidgetData> widgets, CanvasWidgetData widgetToAdd, String targetId) {
    return widgets.map((widget) {
      if (widget.id == targetId) {
        final newChildren = [...widget.children, widgetToAdd];
        return CanvasWidgetData(
          id: widget.id,
          widget: widget.widget,
          position: widget.position,
          size: widget.size,
          color: widget.color,
          key: widget.key,
          children: newChildren,
        );
      }
      return CanvasWidgetData(
        id: widget.id,
        widget: widget.widget,
        position: widget.position,
        size: widget.size,
        color: widget.color,
        key: widget.key,
        children: _addWidgetToTarget(widget.children, widgetToAdd, targetId),
      );
    }).toList();
  }

   List<CanvasWidgetData> _updateWidgetInTree(List<CanvasWidgetData> widgets, CanvasWidgetData widgetToUpdate) {
    return widgets.map((widget) {
      if (widget.id == widgetToUpdate.id) {
        return widgetToUpdate;
      }
      return CanvasWidgetData(
        id: widget.id,
        widget: widget.widget,
        position: widget.position,
        size: widget.size,
        color: widget.color,
        key: widget.key,
        children: _updateWidgetInTree(widget.children, widgetToUpdate),
      );
    }).toList();
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
                      Expanded(
                        flex: 3,
                        child: WidgetTreeView(
                          widgets: _canvasWidgets,
                          selectedId: _selectedWidgetData?.id,
                          onSelected: (id) {
                            final selected = _findWidgetById(_canvasWidgets, id);
                            _onWidgetSelected(selected);
                          },
                          onWidgetMoved: _handleWidgetMove, // Додано обробник
                        ),
                      ),
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
                          canvasWidgets: _canvasWidgets,
                          onWidgetsUpdated: _onWidgetsUpdated,
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
                    onWidgetDeleted: _onWidgetDeleted, // Передаємо функцію видалення
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
