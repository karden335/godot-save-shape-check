@tool
extends VBoxContainer

const SaveShapeAnalyzer = preload("res://addons/save_shape_check/save_shape_analyzer.gd")

var current_path := ""
var released_paths := PackedStringArray()
var current_value: LineEdit
var released_value: Label
var result_value: TextEdit
var run_button: Button
var current_dialog: FileDialog
var released_dialog: FileDialog


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var title := Label.new()
	title.text = "Save Shape Check"
	title.add_theme_font_size_override("font_size", 18)
	add_child(title)

	var explanation := Label.new()
	explanation.text = "Compare representative JSON saves from released builds with the current save shape. Files stay on this computer."
	explanation.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(explanation)

	add_child(_section_label("Current save fixture"))
	var current_row := HBoxContainer.new()
	current_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(current_row)
	current_value = LineEdit.new()
	current_value.placeholder_text = "Choose the current JSON fixture"
	current_value.editable = false
	current_value.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	current_row.add_child(current_value)
	var current_button := Button.new()
	current_button.text = "Choose…"
	current_button.pressed.connect(_choose_current)
	current_row.add_child(current_button)

	add_child(_section_label("Released save fixtures"))
	var released_row := HBoxContainer.new()
	released_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(released_row)
	released_value = Label.new()
	released_value.text = "No files selected"
	released_value.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	released_value.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	released_row.add_child(released_value)
	var released_button := Button.new()
	released_button.text = "Choose…"
	released_button.pressed.connect(_choose_released)
	released_row.add_child(released_button)

	run_button = Button.new()
	run_button.text = "Run compatibility check"
	run_button.disabled = true
	run_button.pressed.connect(_run_check)
	add_child(run_button)

	var hint := Label.new()
	hint.text = "Errors are breaking removals or type changes. Warnings are new fields that need safe defaults."
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(hint)

	result_value = TextEdit.new()
	result_value.editable = false
	result_value.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	result_value.placeholder_text = "Results will appear here."
	result_value.custom_minimum_size = Vector2(0, 240)
	result_value.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(result_value)

	current_dialog = _make_file_dialog(FileDialog.FILE_MODE_OPEN_FILE)
	current_dialog.file_selected.connect(_on_current_selected)
	add_child(current_dialog)

	released_dialog = _make_file_dialog(FileDialog.FILE_MODE_OPEN_FILES)
	released_dialog.files_selected.connect(_on_released_selected)
	add_child(released_dialog)


func _section_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 14)
	return label


func _make_file_dialog(mode: FileDialog.FileMode) -> FileDialog:
	var dialog := FileDialog.new()
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.file_mode = mode
	dialog.use_native_dialog = true
	dialog.add_filter("*.json", "JSON save fixtures")
	return dialog


func _choose_current() -> void:
	current_dialog.popup_file_dialog()


func _choose_released() -> void:
	released_dialog.popup_file_dialog()


func _on_current_selected(path: String) -> void:
	current_path = path
	current_value.text = path
	_refresh_run_state()


func _on_released_selected(paths: PackedStringArray) -> void:
	released_paths = paths
	released_value.text = "%d file%s selected" % [paths.size(), "" if paths.size() == 1 else "s"]
	released_value.tooltip_text = "\n".join(paths)
	_refresh_run_state()


func _refresh_run_state() -> void:
	run_button.disabled = current_path.is_empty() or released_paths.is_empty()


func _run_check() -> void:
	var result := SaveShapeAnalyzer.analyze_files(current_path, released_paths)
	if not result.ok:
		result_value.text = "ERROR\n%s" % result.error
		return

	var lines: PackedStringArray = []
	for report in result.reports:
		lines.append("FIXTURE %s" % report.fixture)
		if report.findings.is_empty():
			lines.append("  PASS: no structural changes detected")
		for finding in report.findings:
			lines.append("  %s %s %s: %s" % [
				finding.severity,
				finding.code,
				finding.path,
				finding.message,
			])
	lines.append("")
	lines.append("SUMMARY: %d fixture(s), %d error(s), %d warning(s)" % [
		result.summary.fixtures,
		result.summary.errors,
		result.summary.warnings,
	])
	result_value.text = "\n".join(lines)

