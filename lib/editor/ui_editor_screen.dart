
import 'package:flutter/material.dart';

class UiEditorScreen extends StatelessWidget {
  const UiEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. Панель інструментів (Toolbar)
          Container(
            height: 30,
            color: Colors.blueGrey[100],
            child: const Center(
              child: Text('Панель інструментів'),
            ),
          ),
          const Divider(height: 1),

          // 2. Основна робоча область
          Expanded(
            child: Row(
              children: [
                // Ліва колонка (Палітра та Дерево)
                Container(
                  width: 200,
                  color: Colors.grey[200],
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Center(child: Text('Палітра віджетів')),
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Colors.grey[300],
                          child: const Center(child: Text('Дерево віджетів')),
                        ),
                      ),
                    ],
                  ),
                ),

                // Центральна колонка (Полотно та Консоль)
                Expanded(
                  child: Column(
                    children: [
                      // Полотно UI
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: const Center(child: Text('Полотно UI')),
                        ),
                      ),
                      const Divider(height: 1),
                      // Рядок стану / Консоль
                      Container(
                        height: 100,
                        color: Colors.black87,
                        child: const Center(
                          child: Text(
                            'Рядок стану / Консоль',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Інспектор властивостей (Права панель)
                Container(
                  width: 200,
                  color: Colors.grey[200],
                  padding: const EdgeInsets.all(8.0),
                  child: const Center(child: Text('Інспектор властивостей')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
