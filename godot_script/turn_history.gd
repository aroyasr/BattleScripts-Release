extends Control
# turn_history.gd
# Manage animation for the turn history timeline scene.
# Instantiates new cells and adds them to an array.
# Displays the 11 most recent turns, by FIFO ordering.

# All cells will be added to Timeline HBOX container, and each time
# a new cell is added the box will be shifted by 150 pixels to the left

# Each cell is 150 Width, 195 Height

@onready var timeline_container = $TimelineContainer
const hbox_start_position: int = 1920

@export var increment = 1
var cell_width = 150
var hbox_position: int = 1920 # This variable will be adjusted by cell width in process
var hbox_destination: int = 1920 # This variable will be adjusted by cell width on new cell added

var num_cells: int = 0

func _ready() -> void:
	increment = Root.bar_increment
	timeline_container.position.x = hbox_start_position
	hbox_position = hbox_start_position
	hbox_destination = hbox_start_position
	if timeline_container.get_child_count() > 0:
		for cell in timeline_container.get_children():
			cell.queue_free()

func _process(_delta: float):
	if hbox_position > hbox_destination:
		if hbox_position - increment < hbox_destination:
			hbox_position = hbox_destination
		else:
			hbox_position = hbox_position - increment
		timeline_container.position.x = hbox_position

func add_turn_cell_to_timeline(turn: int, p1_choice: int, p1_money_earned: int,
					p2_choice: int, p2_money_earned: int):
	var newCell = TurnHistoryCell.create(turn, p1_choice, p1_money_earned, p2_choice, p2_money_earned)
	timeline_container.add_child(newCell)
	hbox_destination = hbox_destination - cell_width
	
