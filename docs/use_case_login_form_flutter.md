## Стрес-тест: Форма входу (Flutter)

Цей приклад описує створення простої форми входу для перевірки гнучкості архітектури.

### Нові `components` (Flutter)

Додамо компоненти, необхідні для форм.

| id | name             | type    | icon           | language |
| -- | ---------------- | ------- | -------------- | -------- |
| 11 | Scaffold         | layout  | `web_asset`    | flutter  |
| 12 | AppBar           | visual  | `web_asset`    | flutter  |
| 13 | TextField        | visual  | `input`        | flutter  |
| 14 | InputDecoration  | style   | `style`        | flutter  |
| 15 | ElevatedButton   | visual  | `smart_button` | flutter  |
| 16 | Padding          | layout  | `padding`      | flutter  |

### Нові `properties` (Flutter)

| component_id      | name          | display_name     | property_type   | primitive_type | component_ref_id    |
| ----------------- | ------------- | ---------------- | --------------- | -------------- | ------------------- |
| 11 (Scaffold)     | body          | Вміст            | `component_ref` | null           | null                |
| 11 (Scaffold)     | appBar        | Панель додатку   | `component_ref` | null           | 12 (AppBar)         |
| 12 (AppBar)       | title         | Заголовок        | `component_ref` | null           | 8 (Text)            |
| 13 (TextField)    | decoration    | Декорація        | `component_ref` | null           | 14 (InputDecoration)|
| 13 (TextField)    | obscureText   | Прихований текст | `primitive`     | `bool`         | null                |
| 14 (InputDecoration)| labelText   | Текст підказки   | `primitive`     | `string`       | null                |
| 15 (ElevatedButton)| onPressed   | Дія при натисканні| `primitive`     | `string`       | null                |
| 15 (ElevatedButton)| child         | Дочірній елемент | `component_ref` | null           | 8 (Text)            |

### Нові `generators` (Flutter)

| component_id      | template |
| ----------------- | -------- |
| 11 (Scaffold)     | `Scaffold(appBar: {{appBar}}, body: {{body}})` |
| 13 (TextField)    | `TextField(obscureText: {{obscureText}}, decoration: {{decoration}})` |
| 14 (InputDecoration)| `InputDecoration(labelText: '{{labelText}}')` |
| 15 (ElevatedButton)| `ElevatedButton(onPressed: () { /* {{onPressed}} */ }, child: {{child}})` |

### "Дерево Екземплярів" для форми входу (Flutter)

```json
{
  "instance_id": "scaffold_01",
  "component_id": 11, // Scaffold
  "properties": {
    "appBar": {
      "instance_id": "appbar_02",
      "component_id": 12, // AppBar
      "properties": {
        "title": {
          "instance_id": "title_03",
          "component_id": 8, // Text
          "properties": {
            "data": "Вхід"
          }
        }
      }
    },
    "body": {
      "instance_id": "padding_04",
      "component_id": 16, // Padding
      "properties": {
        "padding": {
            "instance_id": "padding_val_05",
            "component_id": 10, // EdgeInsets
            "properties": { "all": 16.0 }
        },
        "child": {
          "instance_id": "column_06",
          "component_id": 7, // Column
          "properties": {
            "children": [
              {
                "instance_id": "email_field_07",
                "component_id": 13, // TextField
                "properties": {
                  "decoration": {
                    "instance_id": "email_deco_08",
                    "component_id": 14, // InputDecoration
                    "properties": {
                      "labelText": "Email"
                    }
                  }
                }
              },
              {
                "instance_id": "spacer_09",
                "component_id": 5, // SizedBox
                "properties": { "height": 16.0 }
              },
              {
                "instance_id": "password_field_10",
                "component_id": 13, // TextField
                "properties": {
                  "obscureText": true,
                  "decoration": {
                    "instance_id": "pass_deco_11",
                    "component_id": 14, // InputDecoration
                    "properties": {
                      "labelText": "Пароль"
                    }
                  }
                }
              },
              {
                "instance_id": "spacer_12",
                "component_id": 5, // SizedBox
                "properties": { "height": 24.0 }
              },
              {
                "instance_id": "login_button_13",
                "component_id": 15, // ElevatedButton
                "properties": {
                  "onPressed": "handleLogin",
                  "child": {
                    "instance_id": "button_text_14",
                    "component_id": 8, // Text
                    "properties": {
                      "data": "Увійти"
                    }
                  }
                }
              }
            ]
          }
        }
      }
    }
  }
}
```