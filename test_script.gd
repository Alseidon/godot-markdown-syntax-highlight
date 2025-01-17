@tool
extends EditorScript


func _run() -> void:
	var str: String = "Test 123 __eazaeaèè__"
	var i: int = str.find("__")
	print(i)
	print(str.substr(i, 3))
