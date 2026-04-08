# main.py

# Imports the module responsible for Godot-Python communication
import godot_friend
import gm_main
import sys
import time
import traceback
from pathlib import Path

# Module-level variable to hold the game manager object
gm_obj = None


# Initialise gameManager object. Take scripts paths as params. 
# This function is called by pythonFriend node in godot.
# Returns true if successful, false otherwise.
# params: {
#     "script1_path": str (path to first python script),
#     "script2_path": str (path to second python script)
# }
# 
# then loop to process input from godot, if func is get_turn_results, call get_turn_results and update comm_channel.json with results for godot to read.

def init(params): 
	global gm_obj
	loop_counter = 0
	threshold = 600*5 # 5 minutes at 0.1s sleep per loop
	try:
		script1_path = params.get("script1_path")
		script2_path = params.get("script2_path")
		gm_obj = gm_main.GameManager(script1_path, script2_path, 0, 50)
		#godot_friend.show_debug_message("GameManager initialized with scripts:"+ script1_path + " " + script2_path)
	
	except Exception as e:
		error_msg = f"Failed to initialize GameManager: {str(e)}"
		godot_friend.set_comm_channel_output({"PYTHON_ERROR": "true", "error": error_msg})
		godot_friend.show_debug_message(error_msg)
		sys.exit(1)
	
	while True:
		try:
			data = godot_friend.get_comm_channel_input()
			if data is None:
				time.sleep(0.1)
				loop_counter += 1
				if loop_counter > threshold: 
					exit()
				continue
			
			params = data.get("params", {})

			if params.get("PY_OUTPUT") == "false" and data.get("func") == "get_turn_results":
				loop_counter = 0
				#process turn results and update comm_channel.json with results for godot to read
				turn_results = get_turn_results({})
				godot_friend.set_comm_channel_output({"turn_results": turn_results, "PY_OUTPUT": "true", "GD_OUTPUT": "false"})
				if turn_results["match_finished"]:
					sys.exit(0)
			if data.get("func") == "exit":
				exit()
			
		except Exception as e:
			error_msg = f"Error: {str(e)}"
			godot_friend.set_comm_channel_output({"PYTHON_ERROR": "true", "error": error_msg})
			godot_friend.show_debug_message(error_msg)
			sys.exit(1)
		
		# Add a small delay to prevent CPU spinning and allow proper I/O operations
		time.sleep(0.1)
		loop_counter += 1
		if loop_counter > threshold: 
					exit()

# Run main to process 1 turn, then get current state and return it.
# params: {}
def get_turn_results(params): 
	match_finished = gm_obj.main()
	state = gm_obj.get_state()
	return {"turn": state["turn"],
			"p1_money": state["p1_money"], 
			"p2_money": state["p2_money"],
			"p1_money_earned": state["p1_money_earned"],
			"p2_money_earned": state["p2_money_earned"],
			"p1_last_move": state["p1_last_move"],
			"p2_last_move": state["p2_last_move"],
			"match_finished": match_finished
			}

# Reset comm channel and exit program. Called by godot when exiting the application.
def exit():
	godot_friend.set_comm_channel_output({"turn_results": {}, "PY_OUTPUT": "false", "GD_OUTPUT": "false"})
	sys.exit(0)

# This dictionary maps function names (strings) to their corresponding Python functions, allowing Godot to call them by name.
func_map = {
	"init": init, # Initialise gameManager object. Take scripts paths as params
	"get_turn_results": get_turn_results # Not included because its called internally
	#"exit": exit, # Not included because its called internally
}


if __name__ == "__main__":
	try:
		# Sets the name of the Godot application. This is used to create a directory for communication data within 'godot/app_userdata/<app_name>'.
		# Please, use the name set in "application/config/name" Godot property (or in project config --> Application --> Name)
		app_name = "BattleScripts"
		godot_friend.set_app_name(app_name)
		
		# Makes the Python functions accessible from the Godot application by name.
		godot_friend.add_map(func_map) 
		
		# Set tkinter debug even in export
		godot_friend.set_debug(True)
		
		# Processes input from Godot and executes the corresponding Python function.
		godot_friend.ready()
		
	except Exception as e:
		sys.exit(1)
	