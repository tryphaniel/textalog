extends Control

@onready var text_edit: TextEdit = $VBoxContainer/TextEdit
@onready var text_color_picker = $VBoxContainer/HBoxContainer/TextColorPicker
@onready var background_color_picker = $VBoxContainer/HBoxContainer/BackgroundColorPicker
@onready var foreground_color_picker = $VBoxContainer/HBoxContainer/ForegroundColorPicker

var last_tag = ""

func _on_text_edit_text_changed():
	$DialogBox.dialog_label.text = text_edit.text


func insert_tag(tag: String, options: Variant=null):
	text_edit.begin_complex_operation()
	for i in text_edit.get_caret_count():
		var text = text_edit.get_selected_text(i)
		var insert = "[" + tag
		if options is String:
			insert += "=" + options
		elif options is Dictionary:
			for key in options:
				insert += " " + key + "=" + options[key]
		elif options != null:
			push_error("Invalid tag options: must be String or Dictionary")
			return
		insert += "]" + text + "[/" + tag + "]"
		text_edit.insert_text_at_caret(insert, i)

		var line = text_edit.get_caret_line(i)
		var column = text_edit.get_caret_column(i)
		text_edit.select(line, column, line, column-insert.length(), i)
	last_tag = tag
	text_edit.end_complex_operation()
	text_edit.grab_focus()


func insert_color(tag: String, color: Color):
	if last_tag == tag:
		text_edit.undo()
	insert_tag(tag, "#" + color.to_html())
	await get_tree().process_frame
	last_tag = tag


func _on_text_edit_caret_changed():
	last_tag = ""


func _on_text_color_picker_color_changed(color):
	insert_color("color", color)


func _on_background_color_picker_color_changed(color):
	insert_color("bgcolor", color)


func _on_foreground_color_picker_color_changed(color):
	insert_color("fgcolor", color)



func _on_text_color_picker_pressed():
	insert_color("color", text_color_picker.color)


func _on_background_color_picker_pressed():
	insert_color("bgcolor", background_color_picker.color)


func _on_foreground_color_picker_pressed():
	insert_color("fgcolor", foreground_color_picker.color)
