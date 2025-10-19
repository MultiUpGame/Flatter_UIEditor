
import 'package:flutter/material.dart';
import 'package:myapp/editor/canvas_widget_data.dart';

class PropertiesInspector extends StatelessWidget {
  final CanvasWidgetData? selectedWidgetData;

  const PropertiesInspector({super.key, this.selectedWidgetData});

  @override
  Widget build(BuildContext context) {
    if (selectedWidgetData == null) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Text('Нічого не вибрано'),
        ),
      );
    }

    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Властивості', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('ID: ${selectedWidgetData!.id}'),
          const SizedBox(height: 8),
          Text('Тип: ${selectedWidgetData!.widget.runtimeType}'),
        ],
      ),
    );
  }
}
