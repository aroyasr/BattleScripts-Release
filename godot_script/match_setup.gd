extends Control

## match_setup.gd
## contain methods for picking match settings.
## store location of python files.
## don't allow user to start game without picking 2 files.

@onready var fd_loadp1 = $FD_loadp1
@onready var fd_loadp2 = $FD_loadp2

@onready var p1_loadButton = $CenterContainer/PanelContainer/VBoxContainer/VBoxContainer_buttons/HBoxContainer_P1/button_loadfilep1
@onready var p2_loadButton = $CenterContainer/PanelContainer/VBoxContainer/VBoxContainer_buttons/HBoxContainer_P2/button_loadfilep2
@onready var p1_clearButton = $CenterContainer/PanelContainer/VBoxContainer/VBoxContainer_buttons/HBoxContainer_P1/button_clearfilep1
@onready var p2_clearButton = $CenterContainer/PanelContainer/VBoxContainer/VBoxContainer_buttons/HBoxContainer_P2/button_clearfilep2
@onready var p1_fileLabel = $CenterContainer/PanelContainer/VBoxContainer/VBoxContainer_buttons/HBoxContainer_P1/ScriptName
@onready var p2_fileLabel = $CenterContainer/PanelContainer/VBoxContainer/VBoxContainer_buttons/HBoxContainer_P2/ScriptName

var p1_filepath: String
var p1_filename: String
var p2_filepath: String
var p2_filename: String

var record_match: bool

## validate_script: 
## - Validate the given file has the proper functions needed
## - Calls file_validator.py to achieve this
## - Return null if invalid
## - Return name of script if valid
func validate_script(path: String):
	var pystdout = []
	var validator_script = ProjectSettings.globalize_path("res://addons/python_friend/python_stuff/file_validator.py")
	var script_path = ProjectSettings.globalize_path(path)
	
	# Detect OS and use appropriate Python command
	var python_cmd = "python"
	if OS.get_name() in ["Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD"]:
		python_cmd = "python3"
	
	var result = OS.execute(python_cmd, [validator_script, script_path], pystdout)
	$Window_errormsg.clear_errors()
	# Check if execution was successful (return code 0)
	if result != 0:
		# Validation failed - print errors
		if pystdout.size() > 0:
			print("Validation errors:")
			for error in pystdout:
				$Window_errormsg.add_error(error)
			$Window_errormsg.show()
		return null
	
	# Validation passed - extract script name from output
	if pystdout.size() > 0:
		var script_name = pystdout[0].strip_edges()
		print("Script validated: " + script_name)
		return script_name
	
	return null


# Typical godot functions

# Setting title in inspector does not work so have to do this
func _ready():
	fd_loadp1.title = "Open Player 1 Script"
	fd_loadp2.title = "Open Player 2 Script"
	p1_filepath = ""
	p1_filename = ""
	p2_filepath = ""
	p2_filename = ""

# Button Signals
func _on_button_back_pressed() -> void:
	Root.main_menu()

func _on_button_loadfilep_1_pressed() -> void:
	fd_loadp1.visible = true
func _on_button_loadfilep_2_pressed() -> void:
	fd_loadp2.visible = true


func _on_button_clearfilep_1_pressed() -> void:
	p1_filepath = ""
	p1_filename = ""
	p1_fileLabel.text = ""
	p1_fileLabel.visible = false
	p1_clearButton.visible = false
	p1_loadButton.visible = true
func _on_button_clearfilep_2_pressed() -> void:
	p2_filepath = ""
	p2_filename = ""
	p2_fileLabel.text = ""
	p2_fileLabel.visible = false
	p2_clearButton.visible = false
	p2_loadButton.visible = true

# Filedialog signals
func _on_fd_loadp_1_file_selected(path: String) -> void:
	var script_name = validate_script(path)
	if script_name != null:
		p1_filepath = path
		p1_filename = script_name
		p1_fileLabel.text = p1_filename
		p1_fileLabel.visible = true
		p1_clearButton.visible = true
		p1_loadButton.visible = false


func _on_fd_loadp_2_file_selected(path: String) -> void:
	var script_name = validate_script(path)
	if script_name != null:
		p2_filepath = path
		p2_filename = script_name
		p2_fileLabel.text = p2_filename
		p2_fileLabel.visible = true
		p2_clearButton.visible = true
		p2_loadButton.visible = false


func _on_button_startgame_pressed() -> void:
	if p1_filename == "" or p2_filename == "":
		return # do not allow to run
	Root.p1_script_name = p1_filename
	Root.p1_script_path = p1_filepath
	Root.p2_script_name = p2_filename
	Root.p2_script_path = p2_filepath
	Root.game_controller.change_ui_scene("res://scenes/match.tscn")


func _on_check_box_record_toggled(toggled_on: bool) -> void:
	Root.record_match = toggled_on


func _on_spin_box_value_changed(value: float) -> void:
	Root.bar_increment = int(value)
