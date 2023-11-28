@tool
extends Control

@onready var text_edit: TextEdit = $VBoxContainer/TextEdit
@onready var text_color_picker = $VBoxContainer/ButtonBar/TextColorPicker
@onready var background_color_picker = $VBoxContainer/ButtonBar/BackgroundColorPicker
@onready var foreground_color_picker = $VBoxContainer/ButtonBar/ForegroundColorPicker


func _on_text_edit_text_changed():
	$DialogBox.dialog_label.text = text_edit.text


func insert_tag(tag: String, options: Variant =null, overwrite_tag = true):
	text_edit.begin_complex_operation()
	for i in text_edit.get_caret_count():
		var text = text_edit.get_selected_text(i)
		var line_from = text_edit.get_selection_from_line(i)
		var column_from = text_edit.get_selection_from_column(i)
		var line_to = text_edit.get_selection_to_line(i)
		var column_to = text_edit.get_selection_to_column(i)
		if overwrite_tag and text.begins_with("[" + tag) and text.ends_with("[/" + tag + "]"):
			var found_l = text.substr(0, text.find("]")+1)
			var found_r = "[/" + tag + "]"
			var untag_to = text.length()-found_l.length()-found_r.length()
			var untagged_text = text.substr(found_l.length(), untag_to)
			
			text_edit.delete_selection(i)
			text_edit.insert_text_at_caret(untagged_text, i)
			var line = text_edit.get_caret_line(i)
			var column = text_edit.get_caret_column(i)
			text_edit.select(line_from, column_from, line, column, i)
			if not options:
				continue
			text = text_edit.get_selected_text(i)
			line_from = text_edit.get_selection_from_line(i)
			column_from = text_edit.get_selection_from_column(i)
			line_to = text_edit.get_selection_to_line(i)
			column_to = text_edit.get_selection_to_column(i)

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
		if column_from == -1:
			column_from = column-insert.length()
			line_from = line
		text_edit.select(line_from, column_from, line, column, i)

	text_edit.end_complex_operation()
	text_edit.grab_focus()


func insert_color(tag: String, color: Color):
	insert_tag(tag, "#" + color.to_html())


func _on_text_color_picker_popup_closed():
	insert_color("color", text_color_picker.color)


func _on_background_color_picker_popup_closed():
	insert_color("bgcolor", background_color_picker.color)


func _on_foreground_color_picker_popup_closed():
	insert_color("fgcolor", foreground_color_picker.color)


func _on_play_button_pressed():
	$DialogBox.set_msg(text_edit.text)
