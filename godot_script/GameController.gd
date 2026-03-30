# GameController.gd
# This script manages the currently active scene. It also holds global variables.
class_name GameController extends Node

# Variables
@onready var ui = get_node("current_ui_scene")
var current_ui_scene 
var current_state

# Functions
func _ready() -> void:
	change_ui_scene("res://scenes/main_menu.tscn")

func change_ui_scene(new_scene_path: String):
	if ui.get_child_count() > 0:
		var old_scene = ui.get_child(0)
		old_scene.queue_free()
	var new_scene = load(new_scene_path).instantiate()
	current_ui_scene = new_scene
	ui.add_child(new_scene)
