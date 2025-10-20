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
  final WidgetFactory _widgetFactory = WidgetFactory();
  late TransformationController _transformationController;
  final GlobalKey _interactiveViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _selectWidget(CanvasWidgetData? widgetData) {
    widget.onWidgetSelected(widgetData);
  }

  Widget _buildWidgetUI(CanvasWidgetData widgetData) {
    Widget currentWidget;
    final children = widgetData.childWidgets.map((child) => _buildWidgetUI(child)).toList();

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
        currentWidget = widgetData.widget;
    }

    if (widgetData.size != null && widgetData.widget is! Container) {
        currentWidget = SizedBox(
            width: widgetData.size!.width,
            height: widgetData.size!.height,
            child: currentWidget,
        );
    }

    final isSelected = widget.selectedWidgetData?.id == widgetData.id;
    final scale = _transformationController.value.getMaxScaleOnAxis();

    return GestureDetector(
      onTap: () => _selectWidget(widgetData),
      child: Container(
        decoration: isSelected
            ? BoxDecoration(border: Border.all(color: Colors.blueAccent, width: 2.0 / scale))
            : null,
        child: currentWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topLevelWidgets = widget.canvasWidgets.where((w) => w.parentId == null).toList();

    return GestureDetector(
      onTap: () => _selectWidget(null),
      child: InteractiveViewer(
        key: _interactiveViewerKey,
        transformationController: _transformationController,
        constrained: false,
        minScale: 0.1,
        maxScale: 4.0,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        child: DragTarget<Object>(
          onWillAcceptWithDetails: (details) => details.data is PaletteItem || details.data is CanvasWidgetData,
          onAcceptWithDetails: (details) {
            final scenePosition = _transformationController.toScene(details.offset);

            if (details.data is PaletteItem) {
              final newId = 'widget_${_random.nextInt(100000)}';
              final newWidget = _widgetFactory.createWidgetFromName((details.data as PaletteItem).name);
              final newWidgetData = CanvasWidgetData(
                id: newId,
                widget: newWidget,
                position: scenePosition,
                size: const Size(150, 100),
              );
              final updatedWidgets = [...widget.canvasWidgets, newWidgetData];
              widget.onWidgetsUpdated(updatedWidgets);
              _selectWidget(newWidgetData);
            }
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: 5000,
              height: 5000,
              color: candidateData.isNotEmpty ? Colors.lightGreen[100] : Colors.white,
              child: Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: GridPainter(gridSize: 20.0, controller: _transformationController))),
                  ...topLevelWidgets.map((widgetData) {
                    return DraggableItem(
                      key: ValueKey(widgetData.id),
                      position: widgetData.position,
                      scale: _transformationController.value.getMaxScaleOnAxis(),
                      onTap: () => _selectWidget(widgetData),
                      onDragEnd: (globalPosition) {
                        final RenderBox viewerBox = _interactiveViewerKey.currentContext!.findRenderObject() as RenderBox;
                        final viewerOffset = viewerBox.globalToLocal(globalPosition);
                        final scenePosition = _transformationController.toScene(viewerOffset);
                        
                        final updatedData = widgetData.copyWith(position: scenePosition);
                        final index = widget.canvasWidgets.indexWhere((w) => w.id == widgetData.id);
                        if (index != -1) {
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
      ),
    );
  }
}
