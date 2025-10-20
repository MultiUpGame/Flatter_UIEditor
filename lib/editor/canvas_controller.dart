
import 'package:flutter/foundation.dart';
import 'package:myapp/editor/canvas_widget_data.dart';

/// Контролер, що інкапсулює всю логіку керування станом полотна.
/// Використовує ValueNotifier для повідомлення слухачів про зміни.
class CanvasController {
  /// Сповіщувач для списку віджетів на полотні.
  final ValueNotifier<List<CanvasWidgetData>> canvasWidgetsNotifier =
      ValueNotifier<List<CanvasWidgetData>>([]);

  /// Сповіщувач для вибраного на даний момент віджета.
  final ValueNotifier<CanvasWidgetData?> selectedWidgetDataNotifier =
      ValueNotifier<CanvasWidgetData?>(null);

  // Геттери для зручного доступу до поточних значень
  List<CanvasWidgetData> get canvasWidgets => canvasWidgetsNotifier.value;
  CanvasWidgetData? get selectedWidgetData => selectedWidgetDataNotifier.value;

  /// Викликається, коли користувач вибирає віджет на полотні або в дереві.
  void onWidgetSelected(CanvasWidgetData? widgetData) {
    selectedWidgetDataNotifier.value = widgetData;
  }

  /// Оновлює властивості віджета (наприклад, з інспектора властивостей).
  void onWidgetUpdated(CanvasWidgetData updatedWidgetData) {
    canvasWidgetsNotifier.value =
        _updateWidgetInTree(canvasWidgets, updatedWidgetData);
    // Якщо оновлений віджет є вибраним, оновимо його і в сповіщувачі.
    if (selectedWidgetData?.id == updatedWidgetData.id) {
      selectedWidgetDataNotifier.value = updatedWidgetData;
    }
  }

  /// Повністю замінює список віджетів на полотні.
  void onWidgetsUpdated(List<CanvasWidgetData> updatedWidgets) {
    canvasWidgetsNotifier.value = updatedWidgets;
  }

  /// Видаляє віджет з полотна.
  void onWidgetDeleted(String widgetId) {
    canvasWidgetsNotifier.value = _removeWidgetFromTree(canvasWidgets, widgetId);
    // Якщо видалений віджет був вибраним, знімаємо виділення.
    if (selectedWidgetData?.id == widgetId) {
      selectedWidgetDataNotifier.value = null;
    }
  }

  /// Обробляє перетягування віджета в дереві.
  void handleWidgetMove(String draggedItemId, String targetItemId) {
    final draggedWidget = findWidgetById(canvasWidgets, draggedItemId);
    if (draggedWidget == null) return;

    var newTree = _removeWidgetFromTree(canvasWidgets, draggedItemId);
    newTree = _addWidgetToTarget(newTree, draggedWidget, targetItemId);
    canvasWidgetsNotifier.value = newTree;
  }

  /// Рекурсивно шукає віджет за його ID у дереві.
  CanvasWidgetData? findWidgetById(List<CanvasWidgetData> widgets, String id) {
    for (var widget in widgets) {
      if (widget.id == id) return widget;
      final foundInChildren = findWidgetById(widget.children, id);
      if (foundInChildren != null) return foundInChildren;
    }
    return null;
  }

  /// Рекурсивно видаляє віджет з дерева, повертаючи нове дерево.
  List<CanvasWidgetData> _removeWidgetFromTree(
      List<CanvasWidgetData> widgets, String id) {
    List<CanvasWidgetData> newWidgets = [];
    for (var widget in widgets) {
      if (widget.id != id) {
        final newChildren = _removeWidgetFromTree(widget.children, id);
        newWidgets.add(widget.copyWith(children: newChildren));
      }
    }
    return newWidgets;
  }

  /// Рекурсивно додає віджет до цільового елемента, повертаючи нове дерево.
  List<CanvasWidgetData> _addWidgetToTarget(List<CanvasWidgetData> widgets,
      CanvasWidgetData widgetToAdd, String targetId) {
    return widgets.map((widget) {
      if (widget.id == targetId) {
        final newChildren = [...widget.children, widgetToAdd];
        return widget.copyWith(children: newChildren);
      }
      return widget.copyWith(
          children:
              _addWidgetToTarget(widget.children, widgetToAdd, targetId));
    }).toList();
  }

  /// Рекурсивно оновлює віджет у дереві, повертаючи нове дерево.
  List<CanvasWidgetData> _updateWidgetInTree(
      List<CanvasWidgetData> widgets, CanvasWidgetData widgetToUpdate) {
    return widgets.map((widget) {
      if (widget.id == widgetToUpdate.id) {
        return widgetToUpdate;
      }
      return widget.copyWith(
          children: _updateWidgetInTree(widget.children, widgetToUpdate));
    }).toList();
  }

  /// Очищує ресурси при знищенні контролера.
  void dispose() {
    canvasWidgetsNotifier.dispose();
    selectedWidgetDataNotifier.dispose();
  }
}

// Додамо метод copyWith до CanvasWidgetData для зручності
extension on CanvasWidgetData {
    CanvasWidgetData copyWith({
        List<CanvasWidgetData>? children,
    }) {
        return CanvasWidgetData(
            id: id,
            widget: widget,
            position: position,
            size: size,
            color: color,
            key: key,
            children: children ?? this.children,
        );
    }
}
