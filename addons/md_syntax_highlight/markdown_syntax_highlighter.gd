extends EditorSyntaxHighlighter
class_name MarkdownSyntaxHighlighter

func _get_name() -> String:
	return "Markdown"

func _get_supported_languages() -> PackedStringArray:
	return ["TextFile"]


func _get_line_syntax_highlighting(line: int) -> Dictionary:
	var color_map = {}
	var text_editor = get_text_edit()
	var str = text_editor.get_line(line)

	if str.strip_edges().begins_with("#"):
		color_map[0] = { "color": Color.RED }

	var name_dialog_separator = str.find("::")

	if name_dialog_separator > -1:
		color_map[0] = { "color": Color.BLUE }
		color_map[name_dialog_separator] = { "color": Color.GREEN }
		color_map[name_dialog_separator + 2] = { "color": Color.WHITE }

	return color_map
