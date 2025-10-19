
import 'package:flutter/material.dart';
import 'package:myapp/editor/canvas_widget_data.dart';

class WidgetTreeView extends StatelessWidget {
  final List<CanvasWidgetData> widgets;
  final Function(String) onSelected;
  final String? selectedId;

  const WidgetTreeView({
    super.key,
    required this.widgets,
    required this.onSelected,
    this.selectedId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (context, index) {
        final widgetData = widgets[index];
        return _buildTreeItem(widgetData);
      },
    );
  }

  Widget _buildTreeItem(CanvasWidgetData widgetData) {
    bool isSelected = selectedId == widgetData.id;

    return ListTile(
      title: Text(widgetData.widget.runtimeType.toString()),
      selected: isSelected,
      onTap: () => onSelected(widgetData.id),
      // Рекурсивно будуємо дочірні елементи
      subtitle: widgetData.children.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgetData.children.map(_buildTreeItem).toList(),
              ),
            )
          : null,
    );
  }
}
