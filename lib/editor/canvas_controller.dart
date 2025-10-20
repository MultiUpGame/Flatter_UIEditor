import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/editor/canvas_widget_data.dart';

class CanvasController {
  final ValueNotifier<List<CanvasWidgetData>> canvasWidgetsNotifier =
      ValueNotifier<List<CanvasWidgetData>>([]);
  final ValueNotifier<CanvasWidgetData?> selectedWidgetDataNotifier =
      ValueNotifier<CanvasWidgetData?>(null);

  List<CanvasWidgetData> get canvasWidgets => canvasWidgetsNotifier.value;
  CanvasWidgetData? get selectedWidgetData => selectedWidgetDataNotifier.value;

  void onWidgetSelected(CanvasWidgetData? widgetData) {
    selectedWidgetDataNotifier.value = widgetData;
  }

  void onWidgetsUpdated(List<CanvasWidgetData> updatedWidgets) {
    canvasWidgetsNotifier.value = updatedWidgets;
  }

  void onWidgetUpdated(CanvasWidgetData updatedWidgetData) {
    canvasWidgetsNotifier.value = _updateWidgetInTree(canvasWidgets, updatedWidgetData);
    if (selectedWidgetData?.id == updatedWidgetData.id) {
      selectedWidgetDataNotifier.value = updatedWidgetData;
    }
  }

  void onWidgetDeleted(String widgetId) {
    canvasWidgetsNotifier.value = _removeWidgetFromTree(canvasWidgets, widgetId);
    if (selectedWidgetData?.id == widgetId) {
      selectedWidgetDataNotifier.value = null;
    }
  }

  void handleWidgetMove(String draggedItemId, String? targetItemId) {
    final widgetToMove = findWidgetById(draggedItemId);
    if (widgetToMove == null) return;

    // 1. Видаляємо віджет зі старої позиції
    var newTree = _removeWidgetFromTree(canvasWidgets, draggedItemId);

    // 2. Готуємо віджет до переміщення
    final movedWidget = widgetToMove.copyWith(
      parentId: targetItemId,
      // Скидаємо позицію, якщо віджет стає дочірнім
      position: targetItemId != null ? Offset.zero : widgetToMove.position,
    );

    // 3. Додаємо віджет на нову позицію
    if (targetItemId == null) {
      // Переміщення на верхній рівень
      newTree.add(movedWidget);
    } else {
      // Переміщення в дочірні
      newTree = _addWidgetToTarget(newTree, movedWidget, targetItemId);
    }

    canvasWidgetsNotifier.value = newTree;
  }

  CanvasWidgetData? findWidgetById(String id) {
    for (var widget in canvasWidgets) {
      if (widget.id == id) return widget;
      final foundInChildren = _findRecursive(widget.childWidgets, id);
      if (foundInChildren != null) return foundInChildren;
    }
    return null;
  }

  CanvasWidgetData? _findRecursive(List<CanvasWidgetData> widgets, String id) {
    for (var widget in widgets) {
      if (widget.id == id) return widget;
      final foundInChildren = _findRecursive(widget.childWidgets, id);
      if (foundInChildren != null) return foundInChildren;
    }
    return null;
  }

  List<CanvasWidgetData> _removeWidgetFromTree(List<CanvasWidgetData> widgets, String id) {
    List<CanvasWidgetData> newWidgets = [];
    for (var widget in widgets) {
      if (widget.id != id) {
        final newChildren = _removeWidgetFromTree(widget.childWidgets, id);
        newWidgets.add(widget.copyWith(childWidgets: newChildren));
      }
    }
    return newWidgets;
  }

  List<CanvasWidgetData> _addWidgetToTarget(List<CanvasWidgetData> widgets, CanvasWidgetData widgetToAdd, String targetId) {
    return widgets.map((widget) {
      if (widget.id == targetId) {
        final newChildren = [...widget.childWidgets, widgetToAdd];
        return widget.copyWith(childWidgets: newChildren);
      }
      return widget.copyWith(
          childWidgets: _addWidgetToTarget(widget.childWidgets, widgetToAdd, targetId));
    }).toList();
  }

  List<CanvasWidgetData> _updateWidgetInTree(List<CanvasWidgetData> widgets, CanvasWidgetData widgetToUpdate) {
    return widgets.map((widget) {
      if (widget.id == widgetToUpdate.id) {
        // Зберігаємо дочірні віджети при оновленні, оскільки widgetToUpdate їх не містить
        return widgetToUpdate.copyWith(childWidgets: widget.childWidgets);
      }
      return widget.copyWith(
          childWidgets: _updateWidgetInTree(widget.childWidgets, widgetToUpdate));
    }).toList();
  }

  void dispose() {
    canvasWidgetsNotifier.dispose();
    selectedWidgetDataNotifier.dispose();
  }
}
