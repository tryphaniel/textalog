@tool
extends EditorPlugin

const DialogInspector = preload("res://addons/textalog/commands/dialog/dialog_inspector.gd")
var dialog_editor_plugin
var dialog_editor

func _enter_tree():
	# Initialization of the plugin goes here.
	get_editor_interface().get_base_control().add_child(dialog_editor)
	add_inspector_plugin(dialog_editor_plugin)


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_inspector_plugin(dialog_editor_plugin)


func _init() -> void:
	dialog_editor_plugin = DialogInspector.new()
	dialog_editor_plugin.editor_plugin = self
	
	dialog_editor = DialogInspector.DialogEditorWindow.new()
	dialog_editor.editor_plugin = self
	tree_exited.connect(dialog_editor.queue_free)
