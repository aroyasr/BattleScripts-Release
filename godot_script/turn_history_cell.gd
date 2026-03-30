extends VBoxContainer
class_name TurnHistoryCell

const turnHistoryCell_scene = preload("res://scenes/turn_history_cell.tscn")

var turn := 0
var p1_choice := 0
var p1_money_earned := 0
var p2_choice := 0
var p2_money_earned := 0

@onready var label_turn = $Label_grid1
@onready var label_p1money = $Label_grid2/Money_p1
@onready var label_p1steal = $Label_grid2/Steal_p1
@onready var label_p1support = $Label_grid2/Support_p1
@onready var label_p2money = $Label_grid3/Money_p2
@onready var label_p2steal = $Label_grid3/Steal_p2
@onready var label_p2support = $Label_grid3/Support_p2

static func create(turn, p1_choice, p1_money_earned, p2_choice, p2_money_earned):
	var instance = turnHistoryCell_scene.instantiate()
	instance.turn = turn
	instance.p1_choice = p1_choice
	instance.p1_money_earned = p1_money_earned
	instance.p2_choice = p2_choice
	instance.p2_money_earned = p2_money_earned
	return instance

func _ready():
	label_turn.text = str(turn)
	label_p1steal.visible = p1_choice == Root.STEAL
	label_p1support.visible = p1_choice == Root.SUPPORT
	label_p1money.text = "+ $" + str(p1_money_earned)

	label_p2steal.visible = p2_choice == Root.STEAL
	label_p2support.visible = p2_choice == Root.SUPPORT
	label_p2money.text = "+ $" + str(p2_money_earned)
