@tool
extends EditorSyntaxHighlighter
class_name MarkdownSyntaxHighlighter

const colors_heading: Array[Color] = [Color.RED, Color.ORANGE, Color.YELLOW]
#const colors_list: Array[Color] = [Color.AQUA]
const colors_list: Array[Color] = [Color.CADET_BLUE]

const color_code: Color = Color.LIGHT_SLATE_GRAY
const color_emph: Color = Color.LIGHT_SALMON
const color_strong: Color = Color.SALMON
const color_base: Color = Color.WHITE

#func init_colors_from_theme() -> void:
#var root: Control = EditorInterface.get_base_control()


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
	var regex_start: RegEx = RegEx.new()
	regex_start.compile(r"^\d+[\.\)]")
	var re_match: RegExMatch = regex_start.search(line)
	if re_match != null:
		var numbered_list_marker: int = re_match.get_start()
		var color_map: Dictionary = {
			numbered_list_marker: {"color": colors_list[0]},
			numbered_list_marker + 2: {"color": color_base},
		}
		return color_map
	else:
		return {}


func _add_emph_color_map(line: String) -> Dictionary:
	var regex_underscore: RegEx = RegEx.new()
	regex_underscore.compile(r"([^_](?<emph>_[^_]+_)|(?<emph>_[^_]+_)[^_])")
	var regex_star: RegEx = RegEx.new()
	regex_star.compile(r"([^\*](?<emph>\*[^\*]+\*)|(?<emph>\*[^\*]+\*)[^\*])")
	var re_match_underscore: Array[RegExMatch] = regex_underscore.search_all(line)
	var re_match_star: Array[RegExMatch] = regex_star.search_all(line)
	var color_map: Dictionary = {}
	for m: RegExMatch in re_match_underscore:
		color_map[m.get_start("emph")] = {"color": color_emph}
		color_map[m.get_end("emph")] = {"color": color_base}
	for m: RegExMatch in re_match_star:
		color_map[m.get_start("emph")] = {"color": color_emph}
		color_map[m.get_end("emph")] = {"color": color_base}
	return color_map


func _add_strong_color_map(line: String) -> Dictionary:
	var regex_underscore: RegEx = RegEx.new()
	regex_underscore.compile(r"_{2,}.+_{2,}")
	var regex_star: RegEx = RegEx.new()
	regex_star.compile(r"\*{2,}.+\*{2,}")
	var re_match_underscore: Array[RegExMatch] = regex_underscore.search_all(line)
	var re_match_star: Array[RegExMatch] = regex_star.search_all(line)
	var color_map: Dictionary = {}
	for m: RegExMatch in re_match_underscore:
		color_map[m.get_start()] = {"color": color_strong}
		color_map[m.get_end()] = {"color": color_base}
	for m: RegExMatch in re_match_star:
		color_map[m.get_start()] = {"color": color_strong}
		color_map[m.get_end()] = {"color": color_base}
	return color_map


func _add_code_color_map(line: String) -> Dictionary:
	var color_map: Dictionary = {}
	var regex: RegEx = RegEx.new()
	regex.compile(r"`[^`]+`")
	for m: RegExMatch in regex.search_all(line):
		color_map[m.get_start()] = {"color": color_code}
		color_map[m.get_end()] = {"color": color_base}
	return color_map


func _get_line_syntax_highlighting(line_number: int) -> Dictionary:
	var color_map: Dictionary = {0: {"color": color_base}}
	var text_editor: TextEdit = get_text_edit()
	var line: String = text_editor.get_line(line_number)

	var heading_level: int = _get_heading_level(line)
	if heading_level != -1:
		color_map[0] = {"color": _get_heading_color(heading_level)}
		return color_map

	color_map.merge(_add_list_color_map(line), true)
	color_map.merge(_add_numbered_list_color_map(line), true)
	color_map.merge(_add_emph_color_map(line), true)
	color_map.merge(_add_strong_color_map(line), true)
	color_map.merge(_add_code_color_map(line), true)
	return color_map
