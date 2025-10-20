
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view2/flutter_fancy_tree_view2.dart';
import 'package:myapp/editor/canvas_widget_data.dart';

typedef OnWidgetMoved = void Function(String draggedItemId, String targetItemId);

class WidgetTreeView extends StatefulWidget {
  final List<CanvasWidgetData> widgets;
  final Function(String) onSelected;
  final String? selectedId;
  final OnWidgetMoved onWidgetMoved;

  const WidgetTreeView({
    super.key,
    required this.widgets,
    required this.onSelected,
    this.selectedId,
    required this.onWidgetMoved,
  });

  @override
  State<WidgetTreeView> createState() => _WidgetTreeViewState();
}

class _WidgetTreeViewState extends State<WidgetTreeView> {
  late final TreeController<CanvasWidgetData> _treeController;

  @override
  void initState() {
    super.initState();
    _treeController = TreeController<CanvasWidgetData>(
      roots: widget.widgets,
      childrenProvider: (widgetData) => widgetData.childWidgets,
    );
  }

  @override
  void didUpdateWidget(covariant WidgetTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.widgets != oldWidget.widgets) {
      _treeController.roots = widget.widgets;
    }
  }

  @override
  void dispose() {
    _treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TreeView<CanvasWidgetData>(
      key: ValueKey(widget.widgets.hashCode),
      treeController: _treeController,
      nodeBuilder: (BuildContext context, TreeEntry<CanvasWidgetData> entry) {
        final widgetData = entry.node;
        final isSelected = widget.selectedId == widgetData.id;

        return TreeIndentation(
          entry: entry,
          // Зменшено відступ для компактності
          guide: const ConnectingLinesGuide(indent: 32),
          child: DragTarget<CanvasWidgetData>(
            builder: (context, candidateData, rejectedData) {
              return Draggable<CanvasWidgetData>(
                data: widgetData,
                feedback: Material(
                  elevation: 4.0,
                  child: Opacity(opacity: 0.8, child: _buildNodeContent(widgetData, isSelected, entry)),
                ),
                childWhenDragging: Opacity(opacity: 0.5, child: _buildNodeContent(widgetData, isSelected, entry)),
                child: _buildNodeContent(widgetData, isSelected, entry),
              );
            },
            onWillAcceptWithDetails: (details) => details.data.id != widgetData.id,
            onAcceptWithDetails: (details) {
              widget.onWidgetMoved(details.data.id, widgetData.id);
            },
          ),
        );
      },
    );
  }

  Widget _buildNodeContent(CanvasWidgetData widgetData, bool isSelected, TreeEntry<CanvasWidgetData> entry) {
    return InkWell(
      onTap: () => widget.onSelected(widgetData.id),
      child: Container(
        // Зменшено вертикальні відступи
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center, // Центруємо елементи по вертикалі
          children: [
            // Ключова зміна: SizedBox + Center, щоб уникнути сплющування
            SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: ExpandIcon(
                  key: GlobalObjectKey(entry.node),
                  isExpanded: entry.isExpanded,
                  onPressed: (_) => _treeController.toggleExpansion(entry.node),
                  size: 16,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            _getWidgetIcon(widgetData.widget),
            const SizedBox(width: 4),
            // Зменшено розмір шрифту
            Text(
              widgetData.widget.runtimeType.toString(),
              style: const TextStyle(fontSize: 10, height: 1),
            ),
          ],
        ),
      ),
    );
  }

  Icon _getWidgetIcon(Widget widget) {
    const double iconSize = 12.0; // Зменшено розмір іконок
    switch (widget) {
      case Container _:
        return const Icon(Icons.check_box_outline_blank, size: iconSize);
      case Column _:
        return const Icon(Icons.view_column, size: iconSize);
      case Row _:
        return const Icon(Icons.view_agenda_outlined, size: iconSize);
      case Text _:
        return const Icon(Icons.text_fields, size: iconSize);
      case ElevatedButton _:
        return const Icon(Icons.smart_button, size: iconSize);
      default:
        return const Icon(Icons.widgets, size: iconSize);
    }
  }
}
