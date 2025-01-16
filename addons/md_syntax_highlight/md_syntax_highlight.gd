@tool
extends EditorPlugin

var md_highlighter: MarkdownSyntaxHighlighter

func _enter_tree() -> void:
	print("Hello world")
	md_highlighter = MarkdownSyntaxHighlighter.new()
	EditorInterface.get_script_editor().register_syntax_highlighter(md_highlighter)


func _exit_tree() -> void:
	EditorInterface.get_script_editor().unregister_syntax_highlighter(md_highlighter)
