
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/editor/canvas_widget_data.dart';
import 'package:myapp/editor/widget_factory.dart';
import 'package:myapp/editor/widgets/draggable_item.dart';
import 'package:myapp/editor/widgets_palette_data.dart';

class CanvasView extends StatefulWidget {
  final Function(CanvasWidgetData?) onWidgetSelected;

  const CanvasView({super.key, required this.onWidgetSelected});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  final List<CanvasWidgetData> _canvasWidgets = [];
  final Random _random = Random();
  final GlobalKey _canvasKey = GlobalKey();

  String? _selectedWidgetId;

  void _selectWidget(String? widgetId) {
    setState(() {
      _selectedWidgetId = widgetId;
      if (widgetId == null) {
        widget.onWidgetSelected(null);
      } else {
        final selectedWidget = _canvasWidgets.firstWhere((w) => w.id == widgetId);
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
          final RenderBox canvasBox = _canvasKey.currentContext!.findRenderObject() as RenderBox;
          final localPosition = canvasBox.globalToLocal(details.offset);

          final newId = 'widget_${_random.nextInt(100000)}';
          final newWidgetData = CanvasWidgetData(
            id: newId,
            widget: createWidgetFromName((details.data as PaletteItem).name),
            position: localPosition,
            key: GlobalKey(),
          );

          setState(() {
            _canvasWidgets.add(newWidgetData);
          });
          _selectWidget(newId);
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
                    _selectWidget(widgetData.id);
                  },
                  onDragEnd: (globalPosition) {
                    final RenderBox canvasBox = _canvasKey.currentContext!.findRenderObject() as RenderBox;
                    final localPosition = canvasBox.globalToLocal(globalPosition);
                    setState(() {
                      widgetData.position = localPosition;
                    });
                    _selectWidget(widgetData.id);
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
