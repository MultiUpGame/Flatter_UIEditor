import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/editor/canvas_widget_data.dart';
import 'package:myapp/editor/palette/widgets_palette_data.dart';
import 'package:myapp/editor/widget_factory.dart';
import 'package:myapp/editor/canvas/draggable_item.dart';
import 'package:myapp/editor/canvas/grid_painter.dart';

class CanvasView extends StatefulWidget {
  final Function(CanvasWidgetData?) onWidgetSelected;
  final CanvasWidgetData? selectedWidgetData;
  final List<CanvasWidgetData> canvasWidgets;
  final Function(List<CanvasWidgetData>) onWidgetsUpdated;

  const CanvasView({
    super.key,
    required this.onWidgetSelected,
    required this.canvasWidgets,
    required this.onWidgetsUpdated,
    this.selectedWidgetData,
  });

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  final Random _random = Random();
  final GlobalKey _canvasKey = GlobalKey();

  void _selectWidget(CanvasWidgetData? widgetData) {
    widget.onWidgetSelected(widgetData);
  }

  // Рекурсивна функція для побудови UI віджетів
  Widget _buildWidgetUI(CanvasWidgetData widgetData) {
    Widget currentWidget;

    final children = widgetData.children.map((child) => _buildWidgetUI(child)).toList();

    if (widgetData.widget is Container) {
      currentWidget = Container(
        width: widgetData.size?.width,
        height: widgetData.size?.height,
        decoration: (widgetData.widget as Container).decoration,
        child: children.isNotEmpty ? children.first : null,
      );
    } else if (widgetData.widget is Column) {
      currentWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    } else if (widgetData.widget is Row) {
      currentWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    } else {
      currentWidget = SizedBox(
        width: widgetData.size?.width,
        height: widgetData.size?.height,
        child: widgetData.widget,
      );
    }

    final isSelected = widget.selectedWidgetData?.id == widgetData.id;

    // Обгортаємо віджет у GestureDetector для виділення
    return GestureDetector(
      onTap: () {
        _selectWidget(widgetData);
      },
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 2),
              )
            : null,
        child: currentWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectWidget(null),
      child: DragTarget<Object>(
        onWillAcceptWithDetails: (details) => details.data is PaletteItem,
        onAcceptWithDetails: (details) {
          final RenderBox canvasBox =
              _canvasKey.currentContext!.findRenderObject() as RenderBox;
          final localPosition = canvasBox.globalToLocal(details.offset);

          final newId = 'widget_${_random.nextInt(100000)}';
          final newWidget = createWidgetFromName((details.data as PaletteItem).name);

          final newWidgetData = CanvasWidgetData(
            id: newId,
            widget: newWidget,
            position: localPosition,
            size: const Size(150, 100), // Змінив розмір за замовчуванням
            key: GlobalKey(),
          );

          final updatedWidgets = [...widget.canvasWidgets, newWidgetData];
          widget.onWidgetsUpdated(updatedWidgets);
          _selectWidget(newWidgetData);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            key: _canvasKey,
            color: candidateData.isNotEmpty
                ? Colors.lightGreen[100]
                : Colors.white, // Changed background to white for better grid visibility
            child: Stack(
              children: [
                // Grid background
                Positioned.fill(
                  child: CustomPaint(
                    painter: GridPainter(gridSize: 10.0),
                  ),
                ),
                // Draggable widgets
                ...widget.canvasWidgets.map((widgetData) {
                  return DraggableItem(
                    key: ValueKey(widgetData.id),
                    position: widgetData.position,
                    onTap: () => _selectWidget(widgetData),
                    onDragEnd: (globalPosition) {
                      final RenderBox canvasBox =
                          _canvasKey.currentContext!.findRenderObject() as RenderBox;
                      final localPosition = canvasBox.globalToLocal(globalPosition);

                      final updatedData = CanvasWidgetData(
                        id: widgetData.id,
                        widget: widgetData.widget,
                        position: localPosition,
                        size: widgetData.size,
                        key: widgetData.key,
                        children: widgetData.children,
                      );

                      final index = widget.canvasWidgets.indexWhere((w) => w.id == widgetData.id);
                      if(index != -1) {
                        final updatedWidgets = [...widget.canvasWidgets];
                        updatedWidgets[index] = updatedData;
                        widget.onWidgetsUpdated(updatedWidgets);
                        _selectWidget(updatedData);
                      }
                    },
                    child: _buildWidgetUI(widgetData),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
