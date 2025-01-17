@tool
extends EditorSyntaxHighlighter
class_name MarkdownSyntaxHighlighter

const colors_heading: Array[Color] = [Color.RED, Color.ORANGE, Color.YELLOW]
const colors_list: Array[Color] = [Color.BLUE, Color.BLUE_VIOLET, Color.DARK_VIOLET]

#const color_comment: Color = Color.DIM_GRAY
const color_emph: Color = Color.LIGHT_SALMON
const color_bold: Color = Color.SALMON
const color_base: Color = Color.WHITE


func _get_name() -> String:
	return "Markdown"


func _get_supported_languages() -> PackedStringArray:
	return ["TextFile"]


func _get_heading_level(line: String) -> int:
	if line.begins_with("#"):
		return 1 + _get_heading_level(line.substr(2))
	else:
		return -1


func _add_list_color_map(line: String) -> Dictionary:
	var stripped_line: String = line.strip_edges(true, false)
	if stripped_line.begins_with("-") or stripped_line.begins_with("*"):
		pass
	else:
		return {}


func _get_heading_color(lvl: int) -> Color:
	return colors_heading[lvl % colors_heading.size()]


func _get_list_color(lvl: int) -> Color:
	return colors_list[lvl % colors_list.size()]


func _get_line_syntax_highlighting(line_number: int) -> Dictionary:
	var color_map: Dictionary = {}
	var text_editor: TextEdit = get_text_edit()
	var line: String = text_editor.get_line(line_number)

	var heading_level: int = _get_heading_level(line)
	if heading_level != -1:
		color_map[0] = {"color": _get_heading_color(heading_level)}
		return color_map

	color_map.merge(_add_list_color_map(line))
	return color_map
