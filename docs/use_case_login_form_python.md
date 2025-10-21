## Стрес-тест: Форма входу (Python/CustomTkinter)

Аналогічна форма входу, реалізована для Python, щоб перевірити гнучкість архітектури.

### Нові `components` (Python)

| id  | name          | type   | icon           | language             |
| --- | ------------- | ------ | -------------- | -------------------- |
| 15  | CTkEntry      | visual | `input`        | python-customtkinter |
| 16  | CTkButton     | visual | `smart_button` | python-customtkinter |

(Ми перевикористовуємо `CTkFrame` (id: 12) та `CTkLabel` (id: 13) з попереднього прикладу).

### Нові `properties` (Python)

| component_id    | name           | display_name     | property_type | primitive_type | component_ref_id |
| --------------- | -------------- | ---------------- | ------------- | -------------- | ---------------- |
| 15 (CTkEntry)   | placeholder_text | Текст-заповнювач | `primitive`   | `string`       | null             |
| 15 (CTkEntry)   | show           | Символ заміни    | `primitive`   | `string`       | null             |
| 16 (CTkButton)  | command        | Команда          | `primitive`   | `string`       | null             |
| 16 (CTkButton)  | text           | Текст            | `primitive`   | `string`       | null             |

### Нові `generators` (Python)

Зверніть увагу, як ми використовуємо `{{_instance_variable_}}` для створення та налаштування віджетів у декілька кроків.

| component_id    | template |
| --------------- | -------- |
| 15 (CTkEntry)   | `{{_instance_variable_}} = ctk.CTkEntry({{_parent_variable_}}, placeholder_text="{{placeholder_text}}", show="{{show}}")\n{{_instance_variable_}}.pack(fill="x", pady=4)` |
| 16 (CTkButton)  | `{{_instance_variable_}} = ctk.CTkButton({{_parent_variable_}}, text="{{text}}", command={{command}})\n{{_instance_variable_}}.pack(pady=12)` |

### "Дерево Екземплярів" для форми входу (Python)

```json
{
  "instance_id": "main_frame_01",
  "component_id": 12, // CTkFrame
  "properties": {
    "pady": 20,
    "padx": 20,
    "children": [
      {
        "instance_id": "title_label_02",
        "component_id": 13, // CTkLabel
        "properties": {
          "text": "Вхід",
          "font": {
            "instance_id": "font_03",
            "component_id": 14, // CTkFont
            "properties": {
              "size": 24,
              "weight": "bold"
            }
          }
        }
      },
      {
        "instance_id": "email_entry_04",
        "component_id": 15, // CTkEntry
        "properties": {
          "placeholder_text": "Email"
        }
      },
      {
        "instance_id": "password_entry_05",
        "component_id": 15, // CTkEntry
        "properties": {
          "placeholder_text": "Пароль",
          "show": "*"
        }
      },
      {
        "instance_id": "login_button_06",
        "component_id": 16, // CTkButton
        "properties": {
          "text": "Увійти",
          "command": "handle_login"
        }
      }
    ]
  }
}
```