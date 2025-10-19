
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/editor/canvas_widget_data.dart';
import 'package:myapp/editor/widget_factory.dart';
import 'package:myapp/editor/widgets/draggable_item.dart';
import 'package:myapp/editor/widgets_palette_data.dart';

class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  final List<CanvasWidgetData> _canvasWidgets = [];
  final Random _random = Random();
  final GlobalKey _canvasKey = GlobalKey();

  String? _selectedWidgetId; // ID виділеного віджета

  void _clearSelection() {
    if (_selectedWidgetId != null) {
      setState(() {
        _selectedWidgetId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _clearSelection, // Знімаємо виділення по кліку на порожнє місце
      child: DragTarget<Object>(
        onWillAccept: (data) => data is PaletteItem,
        onAcceptWithDetails: (details) {
          final RenderBox canvasBox = _canvasKey.currentContext!.findRenderObject() as RenderBox;
          final localPosition = canvasBox.globalToLocal(details.offset);

          setState(() {
            final newId = 'widget_${_random.nextInt(100000)}';
            _canvasWidgets.add(
              CanvasWidgetData(
                id: newId,
                widget: createWidgetFromName((details.data as PaletteItem).name),
                position: localPosition,
                key: GlobalKey(),
              ),
            );
            _selectedWidgetId = newId; // Новий віджет одразу стає виділеним
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            key: _canvasKey,
            color: candidateData.isNotEmpty ? Colors.lightGreen[100] : Colors.grey[200],
            child: Stack(
              children: _canvasWidgets.map((widgetData) {
                return DraggableItem(
                  widgetData: widgetData,
                  isSelected: widgetData.id == _selectedWidgetId,
                  onTap: () {
                    setState(() {
                      _selectedWidgetId = widgetData.id;
                    });
                  },
                  onDragEnd: (globalPosition) {
                    final RenderBox canvasBox = _canvasKey.currentContext!.findRenderObject() as RenderBox;
                    final localPosition = canvasBox.globalToLocal(globalPosition);
                    setState(() {
                      widgetData.position = localPosition;
                      _selectedWidgetId = widgetData.id; // Робимо віджет виділеним після перетягування
                    });
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
