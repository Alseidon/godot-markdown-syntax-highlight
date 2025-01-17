@tool
extends EditorScript


func _run() -> void:
	var regex: RegEx = RegEx.new()
	#regex.compile(r"\d(\./\))")
	regex.compile(r"([^\*](?<emph>\*[^\*]+\*)|(?<emph>\*[^\*]+\*)[^\*])")
	var res: Array[RegExMatch] = regex.search_all(
		"*Ehm*... This is a *test* for *emph**sentences or non**sentences*. *Boom*"
	)
	print("---")
	if res.is_empty():
		print("no match")
	else:
		for m: RegExMatch in res:
			print("[|", m.get_string("emph"), "|]")
