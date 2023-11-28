@tool
extends EditorInspectorPlugin
var editor_plugin:EditorPlugin

const CommandDialog = preload("res://addons/textalog/commands/command_dialog.gd")

const DialogEditorPath = preload("res://addons/textalog/commands/dialog/dialog_editor.tscn")

class DialogEditorWindow extends ConfirmationDialog:
	var editor_plugin:EditorPlugin
	func _init() -> void:
		title = "Dialog Editor"
		var dialog_editor = DialogEditorPath.instantiate()
		add_child(dialog_editor)

class DialogEditorButton extends EditorProperty:
	var editor_plugin:EditorPlugin
	var method_button:Button
	var dialog_editor:DialogEditorWindow
	
	func _update_property() -> void:
		var edited_object:CommandDialog = get_edited_object()
		var dialog:String = edited_object.dialog
		var text:String = ""
		var icon:Texture = get_theme_icon("Node", "EditorIcons")

		method_button.text = dialog
	
	func _method_button_pressed() -> void:
		dialog_editor.confirmed.connect(_method_selector_confirmed, CONNECT_ONE_SHOT)
		dialog_editor.popup_centered(Vector2i(1280, 720))

	func _method_selector_confirmed() -> void:
		print("cool")

	func _enter_tree() -> void:
		dialog_editor = editor_plugin.dialog_editor

	func _init() -> void:
		method_button = Button.new()
		method_button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		method_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		method_button.pressed.connect(_method_button_pressed)
		add_child(method_button)
		add_focusable(method_button)

func _can_handle(object: Object) -> bool:
	return object is CommandDialog

func _parse_property(
	object: Object,
	type, # For some reason, setting it typed is inconsistent
	name: String,
	hint_type,
	hint_string: String,
	usage_flags,
	wide: bool ) -> bool:
		if not object:
			# For some reason there's no object?
			return false
		
		var override_property = object.get_meta("__editor_override_property__", true)
		if name == "dialog":
			var dialog_editor_button := DialogEditorButton.new()
			dialog_editor_button.editor_plugin = editor_plugin
			add_property_editor("dialog", dialog_editor_button)
			return override_property
		
		return false
