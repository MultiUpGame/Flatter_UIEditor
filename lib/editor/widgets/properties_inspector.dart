
import 'package:flutter/material.dart';
import 'package:myapp/editor/canvas_widget_data.dart';

class PropertiesInspector extends StatefulWidget {
  final CanvasWidgetData? selectedWidgetData;
  final Function(CanvasWidgetData) onWidgetUpdated;

  const PropertiesInspector({
    super.key,
    this.selectedWidgetData,
    required this.onWidgetUpdated,
  });

  @override
  State<PropertiesInspector> createState() => _PropertiesInspectorState();
}

class _PropertiesInspectorState extends State<PropertiesInspector> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _updateTextController();
  }

  @override
  void didUpdateWidget(covariant PropertiesInspector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedWidgetData != oldWidget.selectedWidgetData) {
      _updateTextController();
    }
  }

  void _updateTextController() {
    if (widget.selectedWidgetData != null && widget.selectedWidgetData!.widget is Text) {
      final textValue = (widget.selectedWidgetData!.widget as Text).data ?? '';
      _textEditingController.text = textValue;
    } else {
      _textEditingController.clear();
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedWidgetData == null) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Text('No widget selected'),
        ),
      );
    }

    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Properties', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('Type: ${widget.selectedWidgetData!.widget.runtimeType}'),
          const SizedBox(height: 8),
          if (widget.selectedWidgetData!.widget is Text)
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Text',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (newText) {
                final currentWidget = widget.selectedWidgetData!;
                final updatedWidget = Text(newText, style: (currentWidget.widget as Text).style);
                final updatedData = CanvasWidgetData(
                  id: currentWidget.id,
                  widget: updatedWidget,
                  position: currentWidget.position,
                  key: currentWidget.key,
                );
                widget.onWidgetUpdated(updatedData);
              },
            ),
        ],
      ),
    );
  }
}
