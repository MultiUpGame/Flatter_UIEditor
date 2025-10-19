
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
        // Передаємо рівень вкладеності 0 для кореневих елементів
        return _buildTreeItem(widgetData, 0, onWidgetMoved);
      },
    );
  }

  Widget _buildTreeItem(CanvasWidgetData widgetData, int level, OnWidgetMoved onWidgetMoved) {
    bool isSelected = selectedId == widgetData.id;

    // Кожен елемент тепер є ціллю для перетягування
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Draggable<String>(
          data: widgetData.id,
          feedback: Material(
            child: Opacity(
              opacity: 0.8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('Переміщення ${widgetData.widget.runtimeType}...'),
              ),
            ),
            elevation: 4.0,
          ),
          childWhenDragging: ListTile(
            leading: SizedBox(width: level * 20.0), // Відступ для імітації дерева
            title: Text(widgetData.widget.runtimeType.toString(), style: TextStyle(color: Colors.grey)),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: level * 20.0), // Відступ
                    _getWidgetIcon(widgetData.widget), // Іконка
                  ],
                ),
                title: Text(widgetData.widget.runtimeType.toString()),
                selected: isSelected,
                selectedTileColor: Colors.blue[50],
                onTap: () => onSelected(widgetData.id),
              ),
              // Рекурсивно будуємо дочірні елементи
              if (widgetData.children.isNotEmpty)
                Column(
                  children: widgetData.children.map((child) => _buildTreeItem(child, level + 1, onWidgetMoved)).toList(),
                ),
            ],
          ),
        );
      },
      onWillAcceptWithDetails: (details) => details.data != widgetData.id,
      onAcceptWithDetails: (details) {
        onWidgetMoved(details.data, widgetData.id);
      },
    );
  }

  // Функція для отримання іконки в залежності від типу віджета
  Icon _getWidgetIcon(Widget widget) {
    switch (widget) {
      case Container _:
        return const Icon(Icons.check_box_outline_blank, size: 20);
      case Column _:
        return const Icon(Icons.view_column, size: 20);
      case Row _:
        return const Icon(Icons.view_agenda_outlined, size: 20);
      case Text _:
        return const Icon(Icons.text_fields, size: 20);
      case ElevatedButton _:
        return const Icon(Icons.smart_button, size: 20);
      default:
        return const Icon(Icons.widgets, size: 20);
    }
  }
}
