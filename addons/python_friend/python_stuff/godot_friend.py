import json
from platformdirs import user_data_dir
from pathlib import Path
import tkinter as tk
from tkinter import messagebox

app_name = "Godot"

debug_enabled = False

godot_data_dir = Path(user_data_dir("godot/app_userdata", app_name, roaming=True))
app_data_dir = godot_data_dir

func_map = {}


def show_debug_message(message):
	if debug_enabled:
		root = tk.Tk()
		root.withdraw()
		messagebox.showinfo("Debug", message)
		root.destroy()


def set_debug(enabled):
	global debug_enabled
	debug_enabled = enabled


def set_app_name(name):
	global app_name
	global app_data_dir
	app_name = name
	app_data_dir = godot_data_dir / app_name


def get_comm_channel_input():
	comm_channel_file = app_data_dir / "comm_channel.json"
	#show_debug_message(f"Checking for comm_channel.json at: {comm_channel_file}")

	if comm_channel_file.exists():
		with open(comm_channel_file, 'r') as file:
			try:
				data = json.load(file)
				#show_debug_message(f"comm_channel.json found and read: {data}")
				return data
			except json.JSONDecodeError as e:
				error_msg = f"Error decoding JSON from comm_channel.json: {str(e)}"
				show_debug_message(error_msg)
				return None

	show_debug_message("comm_channel.json not found.")
	return None


def set_comm_channel_output(data):
	comm_channel_file = app_data_dir / "comm_channel.json"
	with open(comm_channel_file, 'w') as file:
		json.dump(data, file, indent=4)
	#show_debug_message(f"comm_channel.json updated with data: {data}")


def add_map(mapping):
	global func_map
	func_map = mapping


def ready():
	try:
		comm_channel_input = get_comm_channel_input()
		if not comm_channel_input:
			set_comm_channel_output({"error": "No input found.", "PYTHON_ERROR": "true"})
			#show_debug_message("No input found in comm_channel.json.")
			return

		func = comm_channel_input.get("func")
		params = comm_channel_input.get("params")
		#show_debug_message(f"Function requested: {func}\nParameters: {params}")

		if func in func_map:
			data = func_map[func](params)
			set_comm_channel_output(data)
		else:
			error_msg = f"Function '{func}' not found in function map."
			set_comm_channel_output({"error": error_msg, "PYTHON_ERROR": "true"})
			show_debug_message(error_msg)

	except Exception as e:
		error_msg = f"An error occurred: {str(e)}"
		set_comm_channel_output({"error": error_msg, "PYTHON_ERROR": "true"})
		show_debug_message(error_msg)