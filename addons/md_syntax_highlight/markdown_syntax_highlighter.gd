@tool
extends EditorSyntaxHighlighter
class_name MarkdownSyntaxHighlighter

const colors_heading: Array[Color] = [Color.RED, Color.ORANGE, Color.YELLOW]
const colors_list: Array[Color] = [Color.SKY_BLUE]

#const color_comment: Color = Color.DIM_GRAY
var color_emph: Color = Color.LIGHT_SALMON
var color_strong: Color = Color.SALMON
var color_base: Color = Color.WHITE_SMOKE


func init_colors_from_theme() -> void:
	var root: Control = EditorInterface.get_base_control()
	#color_base = root.get_theme_color("base_color", "Editor")
	#color_emph = root.get_theme_color("accent_color", "Editor")


func _get_name() -> String:
	return "Markdown"


func _get_supported_languages() -> PackedStringArray:
	return ["TextFile"]


func _get_heading_level(line: String) -> int:
	if line.begins_with("#"):
		return 1 + _get_heading_level(line.substr(1))
	else:
		return -1


func _get_heading_color(lvl: int) -> Color:
	return colors_heading[lvl % colors_heading.size()]


func _get_list_color(lvl: int) -> Color:
	return colors_list[lvl % colors_list.size()]


#func _get_list_indent_number(line: String, line_nb: int) -> int:
#return 0


func _add_list_color_map(line: String) -> Dictionary:
	var stripped_line: String = line.strip_edges(true, false)
	if (
		stripped_line.begins_with("-")
		or stripped_line.begins_with("*")
		or stripped_line.begins_with("+")
	):
		var list_marker: int = line.find(stripped_line[0])
		return {
			list_marker: {"color": colors_list[0]},
			list_marker + 1: {"color": color_base},
		}
	else:
		return {}


func _add_numbered_list_color_map(line: String) -> Dictionary:
	var stripped_line: String = line.strip_edges(true, false)
	if (
		stripped_line[0] in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
		and stripped_line[1] in [".", ")"]
	):
		var numbered_list_marker: int = line.find(stripped_line[0])
		return {
			numbered_list_marker: {"color": colors_list[0]},
			numbered_list_marker + 2: {"color": color_base},
		}
	else:
		return {}


func _get_line_syntax_highlighting(line_number: int) -> Dictionary:
	var color_map: Dictionary = {0: {"color": color_base}}
	var text_editor: TextEdit = get_text_edit()
	var line: String = text_editor.get_line(line_number)

	var heading_level: int = _get_heading_level(line)
	if heading_level != -1:
		color_map[0] = {"color": _get_heading_color(heading_level)}
		return color_map

	color_map.merge(_add_list_color_map(line))
	color_map.merge(_add_numbered_list_color_map(line))
	return color_map
