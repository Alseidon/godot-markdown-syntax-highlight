@tool
extends EditorScript


func _run() -> void:
	var regex: RegEx = RegEx.new()
	regex.compile(r"^(?<text>\[[^\]]*\])(?<target>\([^\)]*\))")
	var res: RegExMatch = regex.search("[A link !](https://example.com)  zaezaea []()")
	if res != null:
		print("---")
		print("text ---- [|", res.get_string("text"), "|]")
		print("target -- [|", res.get_string("target"), "|]")
