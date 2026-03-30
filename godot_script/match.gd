extends Control

# match.gd
# Run the match.
# Start gm_main python script, get result from imported scripts each turn.
# Display results between turns. Manage waiting and animations.

enum matchState {
	AWAIT_INPUT,
	GET_RESULT,
	AWAIT_RESULT,
	DISPLAY_RESULT,
	PYTHON_ERR,
}

# labels
@onready var turn_label = $center_line/VBoxContainer/turn_count_label
@onready var p1_name_label = $VBoxContainer_p1/p1_name_label
@onready var p2_name_label = $VBoxContainer_p2/p2_name_label
@onready var p1_money_label = $VBoxContainer_p1/p1_money_label
@onready var p2_money_label = $VBoxContainer_p2/p2_money_label
@onready var p1_steal_label = $VBoxContainer_p1/p1_steal_label
@onready var p1_support_label = $VBoxContainer_p1/p1_support_label
@onready var p2_steal_label = $VBoxContainer_p2/p2_steal_label
@onready var p2_support_label = $VBoxContainer_p2/p2_support_label

@onready var anim_p1_steal = $AnimationPlayer/Steal_p1
@onready var anim_p1_support = $AnimationPlayer/Support_p1
@onready var anim_p2_steal = $AnimationPlayer/Steal_p2
@onready var anim_p2_support = $AnimationPlayer/Support_p2

var current_state: matchState = matchState.AWAIT_INPUT
var next_pressed: bool = false
var result_received: bool = false
var match_data: Dictionary
var auto: bool = false

var p1_money = 0
var p2_money = 0
var p1_steal_count = 0
var p1_support_count = 0
var p2_steal_count = 0
var p2_support_count = 0
var curr_turn = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p1_money = 0
	p2_money = 0
	p1_steal_count = 0
	p1_support_count = 0
	p2_steal_count = 0
	p2_support_count = 0
	curr_turn = 0
	p1_name_label.text = Root.p1_script_name
	p2_name_label.text = Root.p2_script_name
	autoplay_buffer_timer()
	$PythonFriend.python_init("init", {"script1_path": Root.p1_script_path, "script2_path": Root.p2_script_path, "GD_OUTPUT": "true", "PY_OUTPUT": "false"})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_state == matchState.PYTHON_ERR:
		return
	
	if next_pressed && current_state == matchState.AWAIT_INPUT:
		next_pressed = false
		change_state(matchState.GET_RESULT)
	
	if current_state == matchState.AWAIT_INPUT:
		auto_mode()
		return
	
	# write to comm file to run next turn
	if current_state == matchState.GET_RESULT:
		$PythonFriend.python_run("get_turn_results", {"GD_OUTPUT": "true", "PY_OUTPUT": "false"})
		change_state(matchState.AWAIT_RESULT)
	
	# read comm file until python output saved
	if current_state == matchState.AWAIT_RESULT:
		if !result_received:
			$AnimationPlayer.play("get_result", -1, 2.0)
		while !result_received:
			var data = $PythonFriend.read_python_output()
			if data.get("PY_OUTPUT") == "true":
				match_data = data.get("turn_results")
				result_received = true
			if data.get("PYTHON_ERROR") == "true":
				result_received = true
				current_state = matchState.PYTHON_ERR
		if !$AnimationPlayer.is_playing():
			change_state(matchState.DISPLAY_RESULT)
	
	if current_state == matchState.DISPLAY_RESULT:
		result_received = false
		display_result()
		$AnimationPlayer.play("display_result", -1, 2.0)
		if match_data.get("match_finished"):
			match_data.set("p1_steal_count", p1_steal_count)
			match_data.set("p1_support_count", p1_support_count)
			match_data.set("p2_steal_count", p2_steal_count)
			match_data.set("p2_support_count", p2_support_count)
			Root.match_data = match_data
			Root.game_controller.change_ui_scene("res://scenes/results.tscn")
		change_state(matchState.AWAIT_INPUT)


func change_state(new_state: matchState):
	current_state = new_state

func display_result():
	#update turn history display
	$TurnHistory.add_turn_cell_to_timeline(int(match_data.get("turn")), match_data.get("p1_last_move"), int(match_data.get("p1_money_earned")), match_data.get("p2_last_move"), int(match_data.get("p2_money_earned")))
	#update stats
	curr_turn = int(match_data.get("turn"))
	p1_money = int(match_data.get("p1_money"))
	p2_money = int(match_data.get("p2_money"))
	
	if match_data.get("p1_last_move") == Root.STEAL:
		p1_steal_count = p1_steal_count + 1
		anim_p1_steal.visible = true
		anim_p1_support.visible = false
	else:
		p1_support_count = p1_support_count + 1
		anim_p1_steal.visible = false
		anim_p1_support.visible = true
		
	if match_data.get("p2_last_move") == Root.STEAL:
		p2_steal_count = p2_steal_count + 1
		anim_p2_steal.visible = true
		anim_p2_support.visible = false
	else:
		p2_support_count = p2_support_count + 1
		anim_p2_steal.visible = false
		anim_p2_support.visible = true
	
	#display new text
	turn_label.text = str(curr_turn)
	p1_money_label.text = "Money: $" + str(p1_money)
	p2_money_label.text = "Money: $" + str(p2_money)
	p1_steal_label.text = "Times steal chosen: " + str(p1_steal_count)
	p1_support_label.text = "Times support chosen: " + str(p1_support_count)
	p2_steal_label.text = "Times steal chosen: " + str(p2_steal_count)
	p2_support_label.text = "Times support chosen: " + str(p2_support_count)

func auto_mode():
	if auto:
		if $TurnHistory.hbox_destination == $TurnHistory.hbox_position:
			_on_button_next_pressed()

func autoplay_buffer_timer():
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.5
	timer.timeout.connect(begin_autoplay)
	self.add_child(timer)
	timer.start()

func begin_autoplay():
	$CheckButton_Autoplay.visible = true

func _on_button_exit_pressed() -> void:
	$PythonFriend.python_run("exit", {})
	Root.game_controller.change_ui_scene("res://scenes/main_menu.tscn")


func _on_button_next_pressed() -> void:
	if current_state == matchState.AWAIT_INPUT:
		next_pressed = true


func _on_check_button_autoplay_toggled(toggled_on: bool) -> void:
	auto = toggled_on
	$Button_next.visible = !auto
