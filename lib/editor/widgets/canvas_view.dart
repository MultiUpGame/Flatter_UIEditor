
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/editor/canvas_widget_data.dart';
import 'package:myapp/editor/widget_factory.dart';
import 'package:myapp/editor/widgets/draggable_item.dart';
import 'package:myapp/editor/widgets_palette_data.dart';

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

  String? _selectedWidgetId;

  @override
  void didUpdateWidget(covariant CanvasView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedWidgetData != null &&
        widget.selectedWidgetData != oldWidget.selectedWidgetData) {
      final index = widget.canvasWidgets
          .indexWhere((w) => w.id == widget.selectedWidgetData!.id);
      if (index != -1) {
        setState(() {
          widget.canvasWidgets[index] = widget.selectedWidgetData!;
        });
      }
    }
  }

  void _selectWidget(String? widgetId, [CanvasWidgetData? data]) {
    setState(() {
      _selectedWidgetId = widgetId;
      if (widgetId == null) {
        widget.onWidgetSelected(null);
      } else {
        final selectedWidget = data ?? widget.canvasWidgets.firstWhere((w) => w.id == widgetId);
        widget.onWidgetSelected(selectedWidget);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectWidget(null),
      child: DragTarget<Object>(
        onWillAccept: (data) => data is PaletteItem,
        onAcceptWithDetails: (details) {
          final RenderBox canvasBox =
              _canvasKey.currentContext!.findRenderObject() as RenderBox;
          final localPosition = canvasBox.globalToLocal(details.offset);

          final newId = 'widget_${_random.nextInt(100000)}';
          final newWidget = createWidgetFromName((details.data as PaletteItem).name);

          Color? initialColor;
          if (newWidget is Container) {
            final decoration = newWidget.decoration as BoxDecoration?;
            initialColor = decoration?.color;
          }

          final newWidgetData = CanvasWidgetData(
            id: newId,
            widget: newWidget,
            position: localPosition,
            size: const Size(100, 50),
            color: initialColor,
            key: GlobalKey(),
          );

          final updatedWidgets = [...widget.canvasWidgets, newWidgetData];
          widget.onWidgetsUpdated(updatedWidgets);
          _selectWidget(newId, newWidgetData);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            key: _canvasKey,
            color: candidateData.isNotEmpty
                ? Colors.lightGreen[100]
                : Colors.grey[200],
            child: Stack(
              children: widget.canvasWidgets.map((widgetData) {
                return DraggableItem(
                  key: widgetData.key,
                  widgetData: widgetData,
                  isSelected: widgetData.id == _selectedWidgetId,
                  onTap: () {
                    _selectWidget(widgetData.id);
                  },
                  onDragEnd: (globalPosition) {
                    final RenderBox canvasBox = _canvasKey.currentContext!
                        .findRenderObject() as RenderBox;
                    final localPosition = canvasBox.globalToLocal(globalPosition);

                    final index = widget.canvasWidgets.indexWhere((w) => w.id == widgetData.id);
                    if (index == -1) return;

                    final updatedData = CanvasWidgetData(
                      id: widgetData.id,
                      widget: widgetData.widget,
                      position: localPosition,
                      size: widgetData.size,
                      color: widgetData.color, // Зберігаємо колір
                      key: widgetData.key,
                    );
                    
                    final updatedWidgets = [...widget.canvasWidgets];
                    updatedWidgets[index] = updatedData;
                    widget.onWidgetsUpdated(updatedWidgets);

                    _selectWidget(updatedData.id, updatedData);
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
