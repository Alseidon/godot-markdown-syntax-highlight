@tool
extends EditorSyntaxHighlighter
class_name MarkdownSyntaxHighlighter

#region Colors
const colors_heading: Array[Color] = [Color.RED, Color.ORANGE, Color.YELLOW]
const colors_list: Array[Color] = [Color.CADET_BLUE]

const color_quote: Color = Color.DIM_GRAY
const color_code: Color = Color.LIGHT_SLATE_GRAY
const color_emph: Color = Color.LIGHT_SALMON
const color_strong: Color = Color.SALMON
const color_base: Color = Color.WHITE

const color_link_text: Color = Color.GREEN_YELLOW
const color_link_target: Color = Color.NAVY_BLUE

const color_debug: Color = Color.GREEN
#endregion

#region Full line regexes
const re_str_header: String = r"^(#{1,6}).*$"
const re_str_quote: String = r"^\s*>.*$"

var re_header: RegEx
var re_quote: RegEx
#endregion

#region Line start regexes
const re_str_list: String = r"^\s*([-\+\*])"
const re_str_nb_list: String = r"^\s*(\d+[\.\)])"

var re_list: RegEx
var re_nb_list: RegEx
#endregion

#region Other regexes

#endregion


#region EditorSyntaxHighlighter overwrite
func _get_name() -> String:
	return "Markdown"


func _get_supported_languages() -> PackedStringArray:
	return ["TextFile"]


#endregion


func check_regexes() -> void:
	if re_header == null:
		re_header = RegEx.new()
		re_header.compile(re_str_header)
	if re_list == null:
		re_list = RegEx.new()
		re_list.compile(re_str_list)
	if re_nb_list == null:
		re_nb_list = RegEx.new()
		re_nb_list.compile(re_str_nb_list)
	if re_quote == null:
		re_quote = RegEx.new()
		re_quote.compile(re_str_quote)


func _get_heading_color(lvl: int) -> Color:
	return colors_heading[lvl % colors_heading.size()]


func _read_char_standard(line: String, idx: int, color_map: Dictionary) -> int:
	if idx >= line.length():
		return line.length()
	match line[idx]:
		"_":
			if idx + 1 == line.length():
				return idx + 1
			if line[idx + 1] == "_":
				#strong
				var end_i: int = line.find("__", idx + 2)
				if end_i != -1:
					color_map[idx] = {"color": color_strong}
					color_map[end_i + 2] = {"color": color_base}
					idx = end_i + 2
				else:
					idx += 1
			else:
				#emph
				var end_i: int = line.find("_", idx + 1)
				if end_i != -1:
					color_map[idx] = {"color": color_emph}
					color_map[end_i + 1] = {"color": color_base}
					idx = end_i + 1
				else:
					idx += 1
		"*":
			if idx + 1 == line.length():
				return idx + 1
			if line[idx + 1] == "*":
				#strong
				var end_i: int = line.find("**", idx + 2)
				if end_i != -1:
					color_map[idx] = {"color": color_strong}
					color_map[end_i + 2] = {"color": color_base}
					idx = end_i + 2
				else:
					idx += 1
			else:
				#emph
				var end_i: int = line.find("*", idx + 1)
				if end_i != -1:
					color_map[idx] = {"color": color_emph}
					color_map[end_i + 1] = {"color": color_base}
					idx = end_i + 1
				else:
					idx += 1
		"`":
			var end_i: int = line.find("`", idx + 1)
			if end_i != 1:
				color_map[idx] = {"color": color_code}
				color_map[end_i + 1] = {"color": color_base}
				idx = end_i + 1
			else:
				idx += 1
		"[":
			var mid_i: int = line.find("](", idx + 1)
			if mid_i != -1:
				var end_i: int = line.find(")", mid_i + 2)
				if end_i != -1:
					color_map[idx] = {"color": color_link_text}
					color_map[mid_i + 1] = {"color": color_link_target}
					color_map[end_i + 1] = {"color": color_base}
					idx = end_i
			else:
				idx += 1
		_:
			idx += 1
	return _read_char_standard(line, idx, color_map)


func _get_line_syntax_highlighting(line_number: int) -> Dictionary:
	check_regexes()
	var color_map: Dictionary = {0: {"color": color_base}}
	var text_editor: TextEdit = get_text_edit()
	var line: String = text_editor.get_line(line_number)
	var re_match: RegExMatch
	# Full line
	re_match = re_header.search(line)
	if re_match != null:
		color_map[0] = {"color": _get_heading_color(re_match.get_string(1).length() - 1)}
		return color_map
	re_match = re_quote.search(line)
	if re_match != null:
		color_map[0] = {"color": color_quote}
		return color_map

	var idx: int = 0
	# Line start
	re_match = re_list.search(line)
	if re_match != null:
		color_map[re_match.get_start(1)] = {"color": colors_list[0]}
		color_map[re_match.get_end(1)] = {"color": color_base}
		idx = re_match.get_end()
	else:
		re_match = re_nb_list.search(line)
		if re_match != null:
			color_map[re_match.get_start(1)] = {"color": colors_list[0]}
			color_map[re_match.get_end(1)] = {"color": color_base}
			idx = re_match.get_end()

	idx = _read_char_standard(line, idx, color_map)
	color_map[idx] = {"color": color_debug}
	color_map[idx + 2] = {"color": color_base}
	return color_map
