extends Control

@onready var title = $MarginContainer/HBoxContainer/VBoxContainer/Label
@onready var desc = $MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/RichTextLabel
@onready var icon = $MarginContainer/HBoxContainer/Icon


func set_evidence(evidence_dict):
	title.text = evidence_dict["name"]
	desc.text = evidence_dict["desc"]
	icon.texture = evidence_dict["icon"]
