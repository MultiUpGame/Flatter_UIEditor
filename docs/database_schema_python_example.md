## Приклад 2: Python (CustomTkinter)

Тепер подивимось, як та сама концепція лягає на імперативний підхід Python з бібліотекою `customtkinter`.

### `components` (Python)

| id  | name                 | type   | icon          | language             |
| --- | -------------------- | ------ | ------------- | -------------------- |
| 11  | CTkScrollableFrame   | visual | `list`        | python-customtkinter |
| 12  | CTkFrame             | visual | `crop_square` | python-customtkinter |
| 13  | CTkLabel             | visual | `title`       | python-customtkinter |
| 14  | CTkFont              | style  | `font_download`| python-customtkinter |

### `properties` (Python)

Тут ми бачимо, як архітектурні відмінності відображаються в базі даних:

| id | component_id           | name     | display_name    | property_type   | primitive_type | component_ref_id | default_value |
| -- | ---------------------- | -------- | --------------- | --------------- | -------------- | ---------------- | ------------- |
| 20 | 11 (CTkScrollableFrame)| fill     | Заповнення      | `primitive`     | `enum`         | null             | `none`        |
| 21 | 11 (CTkScrollableFrame)| expand   | Розширювати     | `primitive`     | `bool`         | null             | `false`       |
| 22 | 12 (CTkFrame)          | side     | Сторона         | `primitive`     | `enum`         | null             | `top`         |
| 23 | 12 (CTkFrame)          | padx     | Відступ по X    | `primitive`     | `int`          | null             | `0`           |
| 24 | 13 (CTkLabel)          | text     | Текст           | `primitive`     | `string`        | null             | `""`        |
| 25 | 13 (CTkLabel)          | font     | Шрифт           | `component_ref` | null           | 14 (CTkFont)     | null          |
| 26 | 14 (CTkFont)           | size     | Розмір          | `primitive`     | `int`          | null             | `12`          |
| 27 | 14 (CTkFont)           | weight   | Насиченість     | `primitive`     | `enum`         | null             | `normal`      |

**Важливе спостереження:** властивості `fill`, `expand`, `side`, `padx` стосуються **розкладки**. У Flutter для цього використовуються окремі віджети (`Expanded`, `Padding`), а в Tkinter — це параметри методів `pack()` або `grid()`. Наша модель дозволяє це відобразити, додаючи ці властивості до самих компонентів.

### `generators` (Python)

Шаблони для імперативного підходу виглядають інакше. Вони часто складаються з кількох рядків і повинні знати ім'я змінної батьківського елемента (`{{_parent_variable_}}`) та власне ім'я (`{{_instance_variable_}}`).

| component_id         | template |
| -------------------- | -------- |
| 11 (CTkScrollableFrame) | `{{_instance_variable_}} = ctk.CTkScrollableFrame({{_parent_variable_}})\n{{_instance_variable_}}.pack(fill="{{fill}}", expand={{expand}})\n{{children}}` |
| 12 (CTkFrame)        | `{{_instance_variable_}} = ctk.CTkFrame({{_parent_variable_}})\n{{_instance_variable_}}.pack(fill="x", padx={{padx}}, pady={{pady}})\n{{children}}` |
| 13 (CTkLabel)        | `{{_instance_variable_}} = ctk.CTkLabel({{_parent_variable_}}, text="{{text}}", font={{font}})\n{{_instance_variable_}}.pack(anchor="w")` |
| 14 (CTkFont)         | `ctk.CTkFont(size={{size}}, weight="{{weight}}")` |

### "Дерево Екземплярів" (Python)

Структура дерева залишається такою ж, але вона посилається на `component_id` з Python-секції нашої бази даних. Це показує, що сама модель дерева є **універсальною**.

```json
{
  "instance_id": "root_frame_001",
  "component_id": 11, // CTkScrollableFrame
  "properties": {
    "fill": "both",
    "expand": true,
    "children": [
      {
        "instance_id": "card_frame_002",
        "component_id": 12, // CTkFrame
        "properties": {
          "padx": 8,
          "pady": 8,
          "children": [
            {
              "instance_id": "label_img_003",
              "component_id": 13, // CTkLabel (as image placeholder)
              "properties": {
                "text": "[Image]",
                "width": 100,
                "side": "left",
                "padx": 16
              }
            },
            {
              "instance_id": "text_container_004",
              "component_id": 12, // CTkFrame
              "properties": {
                "side": "left",
                "fill": "x",
                "expand": true,
                "children": [
                  {
                    "instance_id": "title_005",
                    "component_id": 13, // CTkLabel
                    "properties": {
                      "text": "Заголовок картки",
                      "anchor": "w",
                      "font": {
                        "instance_id": "font_006",
                        "component_id": 14, // CTkFont
                        "properties": {
                          "size": 18,
                          "weight": "bold"
                        }
                      }
                    }
                  },
                  {
                    "instance_id": "subtitle_007",
                    "component_id": 13, // CTkLabel
                    "properties": {
                      "text": "Підзаголовок з описом.",
                      "anchor": "w"
                    }
                  }
                ]
              }
            }
          ]
        }
      }
    ]
  }
}
```