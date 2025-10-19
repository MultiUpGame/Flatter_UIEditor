
import 'package:flutter/material.dart';
import 'package:myapp/editor/canvas_widget_data.dart';

// Нова функція зворотного виклику для обробки переміщення
typedef OnWidgetMoved = void Function(String draggedItemId, String targetItemId);

class WidgetTreeView extends StatelessWidget {
  final List<CanvasWidgetData> widgets;
  final Function(String) onSelected;
  final String? selectedId;
  final OnWidgetMoved onWidgetMoved;

  const WidgetTreeView({
    super.key,
    required this.widgets,
    required this.onSelected,
    required this.onWidgetMoved,
    this.selectedId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (context, index) {
        final widgetData = widgets[index];
        // Ми передаємо onWidgetMoved, щоб його можна було викликати з дочірніх елементів
        return _buildTreeItem(widgetData, onWidgetMoved);
      },
    );
  }

  Widget _buildTreeItem(CanvasWidgetData widgetData, OnWidgetMoved onWidgetMoved) {
    bool isSelected = selectedId == widgetData.id;

    // Кожен елемент тепер є ціллю для перетягування
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        // Обгортаємо Draggable, щоб елемент можна було перетягувати
        return Draggable<String>(
          data: widgetData.id,
          feedback: Material(
            child: Text('  Переміщення ${widgetData.widget.runtimeType}...'),
            elevation: 4.0,
          ),
          childWhenDragging: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text(widgetData.widget.runtimeType.toString()),
              selected: isSelected,
            ),
          ),
          child: ListTile(
            title: Text(widgetData.widget.runtimeType.toString()),
            selected: isSelected,
            onTap: () => onSelected(widgetData.id),
            // Показуємо дочірні елементи, якщо вони є
            subtitle: widgetData.children.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widgetData.children.map((child) => _buildTreeItem(child, onWidgetMoved)).toList(),
                    ),
                  )
                : null,
          ),
        );
      },
      // onWillAccept: віджет не може стати власним дочірнім елементом
      onWillAccept: (draggedId) => draggedId != widgetData.id,
      // Коли віджет кинуто на інший
      onAccept: (draggedId) {
        onWidgetMoved(draggedId, widgetData.id);
      },
    );
  }
}
