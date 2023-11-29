@tool
extends PanelContainer
## Displays the [String] in the Name Box.
##
## Changes the name of the [code]speaker[/code] on the name box[br]
## for the current text.
@onready var rtf_label = $MarginContainer/HBoxContainer/RichTextLabel

## Displays the [String] in the name box.
@export var showname: String = "":
	get:
		if rtf_label:
			showname = rtf_label.text
			return rtf_label.text
		return showname
	set(value):
		showname = value
		if rtf_label:
			rtf_label.text = value


func _ready():
	rtf_label.finished.connect(_on_rich_text_label_finished)


func _on_rich_text_label_finished():
	await get_tree().process_frame
	reset_size()
