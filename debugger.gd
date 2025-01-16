@tool
extends Node
class_name Debugger

var print_this_frame: bool = false


func _ready() -> void:
	enable_print_next_frame.call_deferred()


func _process(_delta: float) -> void:
	if print_this_frame:
		print_this_frame = false
		print("Hello world")
		get_tree().create_timer(5.).timeout.connect(enable_print_next_frame)


func enable_print_next_frame() -> void:
	print_this_frame = true
