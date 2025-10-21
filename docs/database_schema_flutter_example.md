## Приклад: Flutter

Розглянемо приклад списку карток з Flutter. Це допоможе зрозуміти, як дані будуть представлені в базі.

### `components` (Flutter)

| id | name            | type   | icon      | language |
| -- | --------------- | ------ | --------- | -------- |
| 1  | ListView        | visual | `list`    | flutter  |
| 2  | Card            | visual | `credit_card`| flutter  |
| 3  | Row             | layout | `view_week`| flutter  |
| 4  | Image           | visual | `image`   | flutter  |
| 5  | SizedBox        | layout | `space_bar`| flutter  |
| 6  | Expanded        | layout | `open_in_full`| flutter  |
| 7  | Column          | layout | `view_stream`| flutter  |
| 8  | Text            | visual | `title`   | flutter  |
| 9  | TextStyle       | style  | `font_download`| flutter  |
| 10 | EdgeInsets      | style  | `margin`  | flutter  |

### `properties` (Flutter)

| id | component_id | name            | display_name    | property_type         | primitive_type | component_ref_id | default_value |
| -- | ------------ | --------------- | --------------- | --------------------- | -------------- | ---------------- | ------------- |
| 1  | 1 (ListView) | children        | Дочірні елементи | `list_of_components`  | null           | 2 (Card)         | null          |
| 2  | 2 (Card)     | margin          | Зовнішній відступ| `component_ref`       | null           | 10 (EdgeInsets)  | null          |
| 3  | 2 (Card)     | child           | Дочірній елемент | `component_ref`       | null           | 3 (Row)          | null          |
| 4  | 3 (Row)      | children        | Дочірні елементи | `list_of_components`  | null           | null             | null          |
| 5  | 4 (Image)    | network         | URL зображення  | `primitive`           | `string`       | null             | ""          |
| 6  | 5 (SizedBox) | width           | Ширина          | `primitive`           | `double`       | null             | 0.0           |
| 7  | 6 (Expanded) | child           | Дочірній елемент | `component_ref`       | null           | 7 (Column)       | null          |
| 8  | 7 (Column)   | crossAxisAlignment| Вирівнювання    | `primitive`           | `enum`         | null             | `start`       |
| 9  | 7 (Column)   | children        | Дочірні елементи | `list_of_components`  | null           | 8 (Text)         | null          |
| 10 | 8 (Text)     | data            | Текст           | `primitive`           | `string`       | null             | ""          |
| 11 | 8 (Text)     | style           | Стиль тексту    | `component_ref`       | null           | 9 (TextStyle)    | null          |
| 12 | 9 (TextStyle)| fontWeight      | Насиченість     | `primitive`           | `enum`         | null             | `normal`      |
| 13 | 9 (TextStyle)| fontSize        | Розмір шрифту   | `primitive`           | `double`       | null             | 14.0          |
| 14 | 10 (EdgeInsets)| all          | З усіх боків    | `primitive`           | `double`       | null             | 0.0           |

### `generators` (Flutter)

| id | component_id | template |
| -- | ------------ | -------- |
| 1  | 1 (ListView) | `ListView(children: [{{children}}],)` |
| 2  | 2 (Card)     | `Card(margin: {{margin}}, child: {{child}},)` |
| 3  | 8 (Text)     | `Text("{{data}}", style: {{style}},)` |
| 4  | 9 (TextStyle)| `TextStyle(fontWeight: FontWeight.{{fontWeight}}, fontSize: {{fontSize}},)` |
| 5  | 10 (EdgeInsets)| `EdgeInsets.all({{all}})` |

### "Дерево Екземплярів" (Flutter)

```json
{
  "instance_id": "root_001",
  "component_id": 1, // ListView
  "properties": {
    "children": [
      {
        "instance_id": "card_002",
        "component_id": 2, // Card
        "properties": {
          "margin": {
            "instance_id": "margin_003",
            "component_id": 10, // EdgeInsets
            "properties": {
              "all": 8.0
            }
          },
          "child": {
            "instance_id": "row_004",
            "component_id": 3, // Row
            "properties": {
              "children": [
                {
                  "instance_id": "image_005",
                  "component_id": 4, // Image
                  "properties": {
                    "network": "https://picsum.photos/100"
                  }
                },
                {
                  "instance_id": "spacer_006",
                  "component_id": 5, // SizedBox
                  "properties": {
                    "width": 16.0
                  }
                },
                {
                  "instance_id": "exp_007",
                  "component_id": 6, // Expanded
                  "properties": {
                    "child": {
                      "instance_id": "col_008",
                      "component_id": 7, // Column
                      "properties": {
                        "crossAxisAlignment": "start",
                        "children": [
                          {
                            "instance_id": "title_009",
                            "component_id": 8, // Text
                            "properties": {
                              "data": "Заголовок картки",
                              "style": {
                                "instance_id": "style_010",
                                "component_id": 9, // TextStyle
                                "properties": {
                                  "fontWeight": "bold",
                                  "fontSize": 18.0
                                }
                              }
                            }
                          },
                          {
                            "instance_id": "subtitle_011",
                            "component_id": 8, // Text
                            "properties": {
                              "data": "Підзаголовок з описом."
                            }
                          }
                        ]
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      }
    ]
  }
}
```