class_name PythonFriend
extends Node

## Path to the Python interpreter of a virtual environment [br] [br]
## Example:[br]res://addons/python_friend/python_stuff/venv/bin/python3
@export_file("*") var python_interpreter: String = "res://addons/python_friend/python_stuff/venv/Scripts/python.exe"
## Path to the main Python file [br] [br]
## Example:[br]res://addons/python_friend/python_stuff/main.py
@export_file("*.py") var python_main_file: String = "res://addons/python_friend/python_stuff/main.py"
## Name and extension of the python_main_file after being exported [br] [br]
## Examples:[br]
## Linux/MacOS: py_backend [br]
## Windows: py_backend.exe [br] [br]
## Note: This executable must be in the same folder as the Godot app
@export var exec_file_name: String = "py_backend"

## Emitted when Godot receives the output from Python[br] [br]
## [param output] - [Dictionary] with the received data from Python
## [param is_error] - [bool] indicates if an error occurred in the Python script
signal python_output(output, is_error)

# holds the current python thread
var thread

func python_init(func_name: String, params: Dictionary):
	generate_python_input(func_name, params) 
	thread = Thread.new()
	thread.start(execute_python_script)


func python_run(func_name: String, params: Dictionary):
	generate_python_input(func_name, params)


func generate_python_input(function: String, params) -> void:
	var data = {"func": function, "params": params}
	var file_path = "user://comm_channel.json"
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
	else:
		print("Error opening the file.")


func read_python_output() -> Dictionary:
	var file = FileAccess.open("user://comm_channel.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var json_parser = JSON.new()
		var error = json_parser.parse(content)
		file.close()
		if error == OK:
			return json_parser.get_data() 
		else:
			print("Error parsing the output JSON:", json_parser.get_error_message())
			return {}
	else:
		print("Output JSON file not found")
		return {}



func execute_python_script():
	if OS.has_feature("editor"): # needs the Python interpreter and also the main file
		var interpreter_path = ProjectSettings.globalize_path(python_interpreter)
		var main_file = ProjectSettings.globalize_path(python_main_file)
		OS.execute(interpreter_path, [main_file])
		
	# otherwise, only needs the executable
	elif OS.has_feature("linux"):
		var command = "./" + exec_file_name
		OS.execute(command, [])
	
	elif OS.has_feature("windows"):
		var command = exec_file_name
		OS.execute(command, [])

	elif OS.has_feature("macos"):
		var command = "./" + exec_file_name
		OS.execute(command, [])


func get_comm_output():
	var output = read_python_output()
	var is_error = output.has("error")
	call_deferred("emit_signal", "python_output", output, is_error)
