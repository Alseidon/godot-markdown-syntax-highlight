@tool
extends EditorPlugin

var markdown_highlighter: MarkdownSyntaxHighlighter


func _enter_tree() -> void:
	markdown_highlighter = MarkdownSyntaxHighlighter.new()
	var script_editor = EditorInterface.get_script_editor()
	script_editor.register_syntax_highlighter(markdown_highlighter)


func _exit_tree() -> void:
	if is_instance_valid(markdown_highlighter):
		var script_editor = EditorInterface.get_script_editor()
		script_editor.unregister_syntax_highlighter(markdown_highlighter)
		markdown_highlighter = null
