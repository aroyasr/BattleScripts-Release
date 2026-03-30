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

func _ready():
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
