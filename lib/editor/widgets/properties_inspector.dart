
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
  late TextEditingController _textController;
  late TextEditingController _xController;
  late TextEditingController _yController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _xController = TextEditingController();
    _yController = TextEditingController();
    _updateControllers();
  }

  @override
  void didUpdateWidget(covariant PropertiesInspector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedWidgetData != oldWidget.selectedWidgetData) {
      _updateControllers();
    }
  }

  void _updateControllers() {
    if (widget.selectedWidgetData != null) {
      // Оновлюємо контролери позиції
      _xController.text = widget.selectedWidgetData!.position.dx.toStringAsFixed(2);
      _yController.text = widget.selectedWidgetData!.position.dy.toStringAsFixed(2);

      // Оновлюємо контролер тексту, якщо це Text віджет
      if (widget.selectedWidgetData!.widget is Text) {
        final textValue = (widget.selectedWidgetData!.widget as Text).data ?? '';
        _textController.text = textValue;
      } else {
        _textController.clear();
      }
    } else {
      _textController.clear();
      _xController.clear();
      _yController.clear();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  void _updatePosition() {
    final currentData = widget.selectedWidgetData;
    if (currentData == null) return;

    final dx = double.tryParse(_xController.text) ?? currentData.position.dx;
    final dy = double.tryParse(_yController.text) ?? currentData.position.dy;
    final newPosition = Offset(dx, dy);

    if (newPosition != currentData.position) {
      final updatedData = CanvasWidgetData(
        id: currentData.id,
        widget: currentData.widget,
        position: newPosition,
        key: currentData.key,
      );
      widget.onWidgetUpdated(updatedData);
    }
  }
  
  void _updateText(String newText) {
      final currentData = widget.selectedWidgetData;
      if (currentData == null || currentData.widget is! Text) return;

      final updatedWidget = Text(newText, style: (currentData.widget as Text).style);
      final updatedData = CanvasWidgetData(
          id: currentData.id,
          widget: updatedWidget,
          position: currentData.position,
          key: currentData.key,
      );
      widget.onWidgetUpdated(updatedData);
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
          const SizedBox(height: 16),
          
          // --- Position Fields ---
          const Text('Position', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _xController,
                  decoration: const InputDecoration(labelText: 'X', border: OutlineInputBorder()),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => _updatePosition(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _yController,
                  decoration: const InputDecoration(labelText: 'Y', border: OutlineInputBorder()),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                   onSubmitted: (_) => _updatePosition(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // --- Text Field (if applicable) ---
          if (widget.selectedWidgetData!.widget is Text) ...[
             const Text('Text Content', style: TextStyle(fontWeight: FontWeight.w600)),
             const SizedBox(height: 8),
             TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Text',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: _updateText,
              ),
          ]
        ],
      ),
    );
  }
}
