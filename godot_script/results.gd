extends Control

# results.gd
# Set label numbers. not much here

@onready var label_p1_name = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Label
@onready var label_p1_money = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Label2
@onready var label_p1_steal = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Label3
@onready var label_p1_support = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Label4

@onready var label_p2_name = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Label
@onready var label_p2_money = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Label2
@onready var label_p2_steal = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Label3
@onready var label_p2_support = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Label4

func _ready():
	var match_data = Root.match_data
	Root.match_data = null
	label_p1_name.text = "Player 1: " + Root.p1_script_name
	label_p1_money.text = "Money earned.................. $" + str(int(match_data.get("p1_money")))
	label_p1_steal.text = "No. times stolen................ " + str(match_data.get("p1_steal_count"))
	label_p1_support.text = "No. times supported.......... " + str(match_data.get("p1_support_count"))
	
	label_p2_name.text = "Player 2: " + Root.p2_script_name
	label_p2_money.text = "Money earned.................. $" + str(int(match_data.get("p2_money")))
	label_p2_steal.text = "No. times stolen................ " + str(match_data.get("p2_steal_count"))
	label_p2_support.text = "No. times supported.......... " + str(match_data.get("p2_support_count"))
	if Root.record_match:
		record_match(match_data)


# Check if the player's data already exist in the leaderboard,
# if not, add the data
# if yes, add onto existing data
# Then write the updated leaderboard into the json file
func record_match(match_data):
	var file = FileAccess.open("leaderboard.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var json_parser = JSON.new()
		var error = json_parser.parse(content)
		file.close()
		if error == OK:
			var leaderboard_data = json_parser.get_data()
			if leaderboard_data.get(Root.p1_script_name, null) != null:
				var player_data = leaderboard_data.get(Root.p1_script_name)
				player_data.set("Points", player_data.get("Points") + match_data.get("p1_money"))
				player_data.set("Support", player_data.get("Support") + match_data.get("p1_support_count"))
				player_data.set("Steal", player_data.get("Steal") + match_data.get("p1_steal_count"))
				player_data.set("Matches", player_data.get("Matches") + 1)
				leaderboard_data.set(Root.p1_script_name, player_data)
			else:
				var player_data: Dictionary
				player_data.set("Name", Root.p1_script_name)
				player_data.set("Points", match_data.get("p1_money"))
				player_data.set("Support", match_data.get("p1_support_count"))
				player_data.set("Steal", match_data.get("p1_steal_count"))
				player_data.set("Matches", 1)
				leaderboard_data.set(Root.p1_script_name, player_data)
				
			if leaderboard_data.get(Root.p2_script_name, null) != null:
				var player_data = leaderboard_data.get(Root.p2_script_name)
				player_data.set("Points", player_data.get("Points") + match_data.get("p2_money"))
				player_data.set("Support", player_data.get("Support") + match_data.get("p2_support_count"))
				player_data.set("Steal", player_data.get("Steal") + match_data.get("p2_steal_count"))
				player_data.set("Matches", player_data.get("Matches") + 1)
				leaderboard_data.set(Root.p2_script_name, player_data)
			else:
				var player_data: Dictionary
				player_data.set("Name", Root.p2_script_name)
				player_data.set("Points", match_data.get("p2_money"))
				player_data.set("Support", match_data.get("p2_support_count"))
				player_data.set("Steal", match_data.get("p2_steal_count"))
				player_data.set("Matches", 1)
				leaderboard_data.set(Root.p2_script_name, player_data)
				
			file = FileAccess.open("res://leaderboard.json", FileAccess.WRITE)
			if file:
				file.store_string(JSON.stringify(leaderboard_data))
				file.close()
			else:
				print("Error opening the file.")

func _on_button_pressed() -> void:
	Root.main_menu()
