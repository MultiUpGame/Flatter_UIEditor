import 'package:flutter/material.dart';
import '../editor/canvas_widget_data.dart';

/// Відповідає за генерацію Dart коду на основі візуального представлення.
class CodeGenerator {
  /// Генерує повний код для екрану на основі списку віджетів на полотні.
  ///
  /// Цей метод створює код для Scaffold, що містить Stack з усіма віджетами,
  /// кожен з яких обгорнутий у Positioned для точного позиціонування.
  String generateScreenCode(List<CanvasWidgetData> widgets, {String screenName = 'MyGeneratedScreen'}) {
    final String widgetsCode = _generateWidgetsCode(widgets);

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

  /// Генерує код для списку віджетів.
  String _generateWidgetsCode(List<CanvasWidgetData> widgets) {
    final buffer = StringBuffer();
    for (final widgetData in widgets) {
      buffer.writeln(_generateSingleWidgetCode(widgetData));
    }
    return buffer.toString();
  }

  /// Генерує код для одного віджета, враховуючи його позицію та властивості.
  String _generateSingleWidgetCode(CanvasWidgetData widgetData) {
    final widgetCode = _buildWidget(widgetData);

    // Форматуємо код з відступами для кращої читабельності
    return '''
          Positioned(
            left: ${widgetData.position.dx.toStringAsFixed(1)},
            top: ${widgetData.position.dy.toStringAsFixed(1)},
            child: ${widgetCode.trim()},
          ),''';
  }

  /// Створює рядок коду для конкретного віджета на основі його даних.
  /// Аналогічно до `WidgetFactory`, але генерує код, а не віджети.
  String _buildWidget(CanvasWidgetData data) {
    // TODO: Розширити для підтримки властивостей з data.properties
    
    // Використовуємо тип віджета для ідентифікації
    final widgetType = data.widget.runtimeType.toString();
    
    // Задаємо розміри за замовчуванням, якщо вони не визначені
    final width = data.size?.width.toStringAsFixed(1) ?? '150.0';
    final height = data.size?.height.toStringAsFixed(1) ?? '100.0';

    switch (widgetType) {
      case 'Container':
        return '''
Container(
              width: $width,
              height: $height,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                border: Border.all(color: Colors.blue[800]!),
              ),
              child: const Center(child: Text('Container')),
            )''';
      case 'Text':
        return "const Text('Новий текстовий віджет', style: TextStyle(fontSize: 16))";
      case 'Column':
        return '''
const Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Елемент 1'), SizedBox(height: 8), Text('Елемент 2')],
            )''';
      case 'Row':
        return '''
const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Елемент 1'), SizedBox(width: 8), Text('Елемент 2')],
            )''';
      default:
        return "const SizedBox.shrink()"; // Повертаємо "пусте" місце для невідомих віджетів
    }
  }
}
