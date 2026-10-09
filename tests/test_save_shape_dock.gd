extends SceneTree

const SaveShapeDock = preload("res://addons/save_shape_check/save_shape_dock.gd")


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var dock := SaveShapeDock.new()
	root.add_child(dock)
	await process_frame

	dock._on_current_selected("res://addons/save_shape_check/examples/current.json")
	dock._on_released_selected(PackedStringArray([
		"res://addons/save_shape_check/examples/released-v1.json",
	]))
	if dock.run_button.disabled:
		push_error("Run button stayed disabled after valid fixtures were selected")
		quit(1)
		return

	dock._run_check()
	var result_text: String = dock.result_value.text
	if "ERROR REMOVED_PATH" not in result_text:
		push_error("Dock did not show the breaking removal")
		quit(1)
		return
	if "WARNING ADDED_PATH" not in result_text:
		push_error("Dock did not show the added-field warning")
		quit(1)
		return
	if "SUMMARY: 1 fixture(s)" not in result_text:
		push_error("Dock did not show the report summary")
		quit(1)
		return

	dock.current_path = "res://tests/invalid.json"
	dock._run_check()
	if not dock.result_value.text.begins_with("ERROR\n"):
		push_error("Dock did not show invalid JSON as an error")
		quit(1)
		return

	print("PASS: SaveShapeDock end-to-end flow")
	quit(0)
