
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
  final GlobalKey _canvasKey = GlobalKey(); // Ключ для полотна

  @override
  Widget build(BuildContext context) {
    return DragTarget<Object>(
      onWillAccept: (data) => data is PaletteItem,
      // Коли віджет з палітри кинуто на полотно
      onAcceptWithDetails: (details) {
        final RenderBox canvasBox = _canvasKey.currentContext!.findRenderObject() as RenderBox;
        final localPosition = canvasBox.globalToLocal(details.offset);

        setState(() {
          _canvasWidgets.add(
            CanvasWidgetData(
              id: 'widget_${_random.nextInt(100000)}',
              widget: createWidgetFromName((details.data as PaletteItem).name),
              position: localPosition,
              key: GlobalKey(),
            ),
          );
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          key: _canvasKey,
          color: candidateData.isNotEmpty ? Colors.lightGreen[100] : Colors.grey[200],
          child: Stack(
            children: _canvasWidgets.map((widgetData) {
              // Використовуємо наш новий віджет для перетягування
              return DraggableItem(
                widgetData: widgetData,
                onDragEnd: (globalPosition) {
                  final RenderBox canvasBox = _canvasKey.currentContext!.findRenderObject() as RenderBox;
                  final localPosition = canvasBox.globalToLocal(globalPosition);
                  setState(() {
                    widgetData.position = localPosition;
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
