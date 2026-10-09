extends SceneTree

const SaveShapeAnalyzer = preload("res://addons/save_shape_check/save_shape_analyzer.gd")

var failures: Array[String] = []


func _init() -> void:
	_test_identical_values_pass()
	_test_breaking_and_additive_changes_are_separate()
	_test_array_item_types()
	_test_json_pointer_escaping()
	_test_file_report()
	_test_invalid_json()

	if failures.is_empty():
		print("PASS: SaveShapeAnalyzer (6 tests)")
		quit(0)
		return
	for failure in failures:
		push_error(failure)
	quit(1)


func _test_identical_values_pass() -> void:
	_expect_equal([], SaveShapeAnalyzer.compare({"value": 1}, {"value": 1}), "identical values")


func _test_breaking_and_additive_changes_are_separate() -> void:
	var findings := SaveShapeAnalyzer.compare(
		{"kept": 1, "removed": true},
		{"kept": 1, "added": "new"},
	)
	var codes: Array[String] = []
	for finding in findings:
		codes.append("%s:%s" % [finding.severity, finding.code])
	_expect_equal(
		["ERROR:REMOVED_PATH", "WARNING:ADDED_PATH"],
		codes,
		"removed and added fields",
	)


func _test_array_item_types() -> void:
	var findings := SaveShapeAnalyzer.compare([1, 2], ["1", "2"], "/items")
	_expect_equal(1, findings.size(), "array type finding count")
	_expect_equal("ARRAY_ITEM_TYPES_CHANGED", findings[0].code, "array type finding code")


func _test_json_pointer_escaping() -> void:
	var findings := SaveShapeAnalyzer.compare({"a/b~c": 1}, {})
	_expect_equal("/a~1b~0c", findings[0].path, "JSON Pointer escaping")


func _test_file_report() -> void:
	var result := SaveShapeAnalyzer.analyze_files(
		"res://addons/save_shape_check/examples/current.json",
		PackedStringArray(["res://addons/save_shape_check/examples/released-v1.json"]),
	)
	_expect_equal(true, result.ok, "file report parses")
	_expect_equal(1, result.summary.fixtures, "file report fixture count")
	_expect_equal(true, result.summary.errors > 0, "file report finds breaking changes")
	_expect_equal(true, result.summary.warnings > 0, "file report finds additions")


func _test_invalid_json() -> void:
	var result := SaveShapeAnalyzer.parse_json_file("res://tests/invalid.json")
	_expect_equal(false, result.ok, "invalid JSON is rejected")


func _expect_equal(expected: Variant, actual: Variant, label: String) -> void:
	if expected != actual:
		failures.append("%s: expected %s, got %s" % [label, expected, actual])

