@tool
extends RefCounted


static func value_kind(value: Variant) -> String:
	match typeof(value):
		TYPE_NIL:
			return "null"
		TYPE_BOOL:
			return "boolean"
		TYPE_INT, TYPE_FLOAT:
			return "number"
		TYPE_STRING:
			return "string"
		TYPE_ARRAY:
			return "array"
		TYPE_DICTIONARY:
			return "object"
		_:
			return type_string(typeof(value))


static func escape_json_pointer(value: String) -> String:
	return value.replace("~", "~0").replace("/", "~1")


static func compare(old_value: Variant, current_value: Variant, path: String = "") -> Array[Dictionary]:
	var display := path if not path.is_empty() else "/"
	var old_kind := value_kind(old_value)
	var current_kind := value_kind(current_value)
	if old_kind != current_kind:
		return [{
			"severity": "ERROR",
			"code": "TYPE_CHANGED",
			"path": display,
			"message": "type changed from %s to %s" % [old_kind, current_kind],
		}]

	var findings: Array[Dictionary] = []
	if old_value is Dictionary:
		var old_keys: Array = old_value.keys()
		var current_keys: Array = current_value.keys()
		old_keys.sort()
		current_keys.sort()

		for key_value in old_keys:
			var key := str(key_value)
			if not current_value.has(key_value):
				findings.append({
					"severity": "ERROR",
					"code": "REMOVED_PATH",
					"path": "%s/%s" % [path, escape_json_pointer(key)],
					"message": "released field is absent from current fixture",
				})

		for key_value in current_keys:
			var key := str(key_value)
			if not old_value.has(key_value):
				findings.append({
					"severity": "WARNING",
					"code": "ADDED_PATH",
					"path": "%s/%s" % [path, escape_json_pointer(key)],
					"message": "released fixture lacks the current field; add a safe default",
				})

		for key_value in old_keys:
			if current_value.has(key_value):
				var key := str(key_value)
				findings.append_array(compare(
					old_value[key_value],
					current_value[key_value],
					"%s/%s" % [path, escape_json_pointer(key)],
				))
	elif old_value is Array and not old_value.is_empty() and not current_value.is_empty():
		var before := _array_item_kinds(old_value)
		var after := _array_item_kinds(current_value)
		if before != after:
			findings.append({
				"severity": "ERROR",
				"code": "ARRAY_ITEM_TYPES_CHANGED",
				"path": display,
				"message": "array item types changed from %s to %s" % [before, after],
			})
		elif before == ["object"]:
			findings.append_array(compare(
				old_value[0],
				current_value[0],
				"%s/*" % display.trim_suffix("/"),
			))
	return findings


static func parse_json_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {"ok": false, "error": "%s: file does not exist" % path}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"ok": false, "error": "%s: could not open file" % path}
	var parser := JSON.new()
	var error := parser.parse(file.get_as_text())
	if error != OK:
		return {
			"ok": false,
			"error": "%s:%d: %s" % [path, parser.get_error_line(), parser.get_error_message()],
		}
	return {"ok": true, "value": parser.data}


static func analyze_files(current_path: String, released_paths: PackedStringArray) -> Dictionary:
	var current := parse_json_file(current_path)
	if not current.ok:
		return {"ok": false, "error": current.error}

	var reports: Array[Dictionary] = []
	var errors := 0
	var warnings := 0
	for released_path in released_paths:
		var released := parse_json_file(released_path)
		if not released.ok:
			return {"ok": false, "error": released.error}
		var findings := compare(released.value, current.value)
		for finding in findings:
			if finding.severity == "ERROR":
				errors += 1
			elif finding.severity == "WARNING":
				warnings += 1
		reports.append({"fixture": released_path, "findings": findings})
	return {
		"ok": true,
		"reports": reports,
		"summary": {
			"fixtures": released_paths.size(),
			"errors": errors,
			"warnings": warnings,
		},
	}


static func _array_item_kinds(values: Array) -> Array[String]:
	var unique: Dictionary = {}
	for value in values:
		unique[value_kind(value)] = true
	var result: Array[String] = []
	for key in unique.keys():
		result.append(str(key))
	result.sort()
	return result

