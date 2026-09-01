extends Node
# global.gd
# provide global methods and variables for whole program

var game_controller : GameController

var p1_script_path: String
var p1_script_name: String
var p2_script_path: String 
var p2_script_name: String

var match_data
var bar_increment : int = 2

var auto_enabled: bool = false
var record_match: bool = false

var STEAL = 0
var SUPPORT = 1

var python_interpreter = ""

func get_python_interpreter():
	var out = []

	if (OS.has_feature("windows")):
		OS.execute("where", ["python"], out)

		if (out):
			python_interpreter = out[0].split("\r\n")[0]
		else:
			get_tree().quit()
	elif (OS.has_feature("linux")):
		OS.execute("which", ["python3"], out)
		
		if (out.is_empty()):
			OS.execute("which", ["python"], out)
		
		if (out):
			python_interpreter = out[0].split("\n")[0]
		else:
			get_tree().quit()

func _ready():
	get_python_interpreter()

	# Extract scripts
	extract_script("res://addons/python_friend/python_stuff/file_validator.py", "user://file_validator.py")
	extract_script("res://addons/python_friend/python_stuff/script.py", "user://script.py")
	extract_script("res://addons/python_friend/python_stuff/main.py", "user://main.py")
	extract_script("res://addons/python_friend/python_stuff/godot_friend.py", "user://godot_friend.py")
	extract_script("res://addons/python_friend/python_stuff/gm_main.py", "user://gm_main.py")

	game_controller = get_parent().get_child(1)

# Global functions
func new_game():
	game_controller.change_ui_scene("res://scenes/match_setup.tscn")
	
func leaderboard():
	game_controller.change_ui_scene("res://scenes/leaderboard.tscn")

func main_menu():
	game_controller.change_ui_scene("res://scenes/main_menu.tscn")

func quit():
	get_tree().quit()

func extract_script(source, dest) -> String:
	if FileAccess.file_exists(dest):
		return ProjectSettings.globalize_path(dest)

	# Read packed file
	var content = FileAccess.get_file_as_string(source)

	# Write real file
	var file = FileAccess.open(dest, FileAccess.WRITE)
	file.store_string(content)
	file.close()

	# Convert user:// to actual OS path
	return ProjectSettings.globalize_path(dest)
