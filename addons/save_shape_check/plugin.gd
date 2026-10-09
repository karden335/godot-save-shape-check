@tool
extends EditorPlugin

const SaveShapeDock = preload("res://addons/save_shape_check/save_shape_dock.gd")

var dock: Control


func _enter_tree() -> void:
	dock = SaveShapeDock.new()
	dock.name = "Save Shape Check"
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)


func _exit_tree() -> void:
	if is_instance_valid(dock):
		remove_control_from_docks(dock)
		dock.queue_free()
	dock = null

