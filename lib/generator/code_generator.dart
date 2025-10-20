import 'package:flutter/material.dart';
import '../editor/canvas_widget_data.dart';

/// Відповідає за генерацію Dart коду на основі візуального представлення.
class CodeGenerator {
  /// Генерує повний код для екрану на основі списку віджетів на полотні.
  String generateScreenCode(List<CanvasWidgetData> widgets, {String screenName = 'MyGeneratedScreen'}) {
    // Ми генеруємо код тільки для віджетів верхнього рівня (без батьків)
    final topLevelWidgets = widgets.where((w) => w.parentId == null).toList();
    final String widgetsCode = _generateWidgetsCode(topLevelWidgets);

    return '''
import 'package:flutter/material.dart';

class $screenName extends StatelessWidget {
  const $screenName({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$screenName'),
      ),
      body: Stack(
        children: [
$widgetsCode
        ],
      ),
    );
  }
}
''';
  }

  /// Генерує код для списку віджетів, що позиціонуються на полотні.
  String _generateWidgetsCode(List<CanvasWidgetData> widgets) {
    final buffer = StringBuffer();
    for (final widgetData in widgets) {
      final widgetCode = _buildWidget(widgetData);
      // Кожен віджет верхнього рівня обгортаємо в Positioned
      buffer.writeln('''
          Positioned(
            left: ${widgetData.position.dx.toStringAsFixed(1)},
            top: ${widgetData.position.dy.toStringAsFixed(1)},
            child: ${widgetCode.trim()},
          ),''');
    }
    return buffer.toString();
  }

  /// Рекурсивно створює рядок коду для конкретного віджета та його дочірніх елементів.
  String _buildWidget(CanvasWidgetData data) {
    final widgetType = data.widget.runtimeType.toString();
    final width = data.size?.width.toStringAsFixed(1);
    final height = data.size?.height.toStringAsFixed(1);

    // Рекурсивно генеруємо код для дочірніх віджетів
    final childrenCode = data.childWidgets.map((child) => _buildWidget(child)).join(',\n');

    String widgetCode;

    switch (widgetType) {
      case 'Container':
        final container = data.widget as Container;
        final decoration = container.decoration as BoxDecoration?;
        final colorCode = _getColorCode(decoration?.color);
        final childCode = data.childWidgets.isNotEmpty ? 'child: ${_buildWidget(data.childWidgets.first)}' : 'child: const Center(child: Text(\'Container\'))';

        widgetCode = '''
Container(
              decoration: BoxDecoration(
                color: $colorCode,
                border: Border.all(color: Colors.blue[800]!),
              ),
              $childCode,
            )''';
        break;

      case 'Text':
        final textWidget = data.widget as Text;
        widgetCode = "Text('${textWidget.data}', style: const TextStyle(fontSize: 16))";
        break;

      case 'Column':
        widgetCode = '''
Column(
              mainAxisSize: MainAxisSize.min,
              children: [$childrenCode],
            )''';
        break;

      case 'Row':
        widgetCode = '''
Row(
              mainAxisSize: MainAxisSize.min,
              children: [$childrenCode],
            )''';
        break;

      default:
        widgetCode = "const SizedBox.shrink()";
        break;
    }

    // Обгортаємо віджет у SizedBox, якщо задано розмір
    if (width != null && height != null) {
      // Для Container розмір застосовується напряму, тому SizedBox не потрібен
      if (widgetType == 'Container') {
         return widgetCode.replaceFirst('Container(', 'Container(\nwidth: $width,\nheight: $height,');
      } 
      return 'SizedBox(\nwidth: $width,\nheight: $height,\nchild: $widgetCode,\n)';
    }

    return widgetCode;
  }

  /// Допоміжна функція для генерації коду кольору.
  String _getColorCode(Color? color) {
    if (color == null) return 'Colors.transparent';
    return 'Color(0x${color.value.toRadixString(16).padLeft(8, '0')})';
  }
}
