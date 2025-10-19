
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
  late TextEditingController _widthController;
  late TextEditingController _heightController;

  Color? _currentColor;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _xController = TextEditingController();
    _yController = TextEditingController();
    _widthController = TextEditingController();
    _heightController = TextEditingController();
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
      final data = widget.selectedWidgetData!;
      _xController.text = data.position.dx.toStringAsFixed(2);
      _yController.text = data.position.dy.toStringAsFixed(2);
      _widthController.text = data.size?.width.toStringAsFixed(2) ?? '';
      _heightController.text = data.size?.height.toStringAsFixed(2) ?? '';
      _currentColor = data.color;

      if (data.widget is Text) {
        _textController.text = (data.widget as Text).data ?? '';
      } else {
        _textController.clear();
      }
    } else {
      _textController.clear();
      _xController.clear();
      _yController.clear();
      _widthController.clear();
      _heightController.clear();
      _currentColor = null;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _textController.dispose();
    _xController.dispose();
    _yController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _updateWidget({Color? newColor}) {
    final currentData = widget.selectedWidgetData;
    if (currentData == null) return;

    final dx = double.tryParse(_xController.text) ?? currentData.position.dx;
    final dy = double.tryParse(_yController.text) ?? currentData.position.dy;
    final newPosition = Offset(dx, dy);

    final width = double.tryParse(_widthController.text);
    final height = double.tryParse(_heightController.text);
    final newSize = (width != null && height != null) ? Size(width, height) : currentData.size;
    
    Widget updatedInternalWidget = currentData.widget;
    final finalColor = newColor ?? _currentColor;

    if (currentData.widget is Container) {
        final existingDecoration = (currentData.widget as Container).decoration as BoxDecoration?;
        updatedInternalWidget = Container(
            decoration: existingDecoration?.copyWith(color: finalColor) ?? BoxDecoration(color: finalColor),
            child: (currentData.widget as Container).child,
        );
    } else if (currentData.widget is Text) {
        final newText = _textController.text;
        if (newText != (currentData.widget as Text).data) {
            updatedInternalWidget = Text(newText, style: (currentData.widget as Text).style);
        }
    }

    final updatedData = CanvasWidgetData(
      id: currentData.id,
      widget: updatedInternalWidget,
      position: newPosition,
      size: newSize,
      color: finalColor,
      key: currentData.key,
    );
    widget.onWidgetUpdated(updatedData);
  }
  
  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _currentColor ?? Colors.blue,
            onColorChanged: (color) => setState(() => _currentColor = color),
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Done'),
            onPressed: () {
              _updateWidget(newColor: _currentColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
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
          
          const Text('Position', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _xController,
                  decoration: const InputDecoration(labelText: 'X', border: OutlineInputBorder()),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => _updateWidget(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _yController,
                  decoration: const InputDecoration(labelText: 'Y', border: OutlineInputBorder()),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                   onSubmitted: (_) => _updateWidget(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const Text('Size', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _widthController,
                  decoration: const InputDecoration(labelText: 'Width', border: OutlineInputBorder()),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => _updateWidget(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _heightController,
                  decoration: const InputDecoration(labelText: 'Height', border: OutlineInputBorder()),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                   onSubmitted: (_) => _updateWidget(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (widget.selectedWidgetData!.widget is Text) ...[
             const Text('Text Content', style: TextStyle(fontWeight: FontWeight.w600)),
             const SizedBox(height: 8),
             TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Text',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _updateWidget(),
              ),
          ],
          if (widget.selectedWidgetData!.widget is Container) ...[
            const Text('Color', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showColorPicker,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: _currentColor,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}
