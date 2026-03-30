extends Control


@onready var grid = $ScrollContainer/GridContainer
@onready var button_sort = $PanelContainer/VBoxContainer/VBoxContainer/VBoxContainer_buttons/Button_sort

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	read_leaderboard_file()
	sort_leaderboard()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func read_leaderboard_file():
	var file = FileAccess.open("leaderboard.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var json_parser = JSON.new()
		var error = json_parser.parse(content)
		file.close()
		if error == OK:
			var leaderboard_data = json_parser.get_data()
			for key in leaderboard_data:
				var script_data = leaderboard_data.get(key)
				add_leaderboard_entry(script_data.get("Name"), script_data.get("Points"), script_data.get("Support"), script_data.get("Steal"), script_data.get("Matches"))
		else:
			print("Error in JSON: " , error)
	else:
		print("File does not exist")


func clear_leaderboard_file():
	var file = FileAccess.open("leaderboard.json", FileAccess.WRITE)
	if file:
		var new_file: Dictionary = {}
		file.store_string(JSON.stringify(new_file))
	else:
		print("File does not exist")
		
	# ensure header labels always appear on top
	var header_array = [] # Store header labels
	for i in 5:
		header_array.append(grid.get_child(i))
	for node in grid.get_children():
		grid.remove_child(node)
	for node in header_array:
		grid.add_child(node)

enum SortOption{
	MONEY,
	STEAL,
	SUPPORT,
	MATCHES,
}
var sort_option: SortOption = SortOption.MONEY
func sort_leaderboard():
	# ensure header labels always appear on top
	var header_array = [] # Store header labels
	for i in 5:
		header_array.append(grid.get_child(i))
	for i in 5:
		grid.remove_child(grid.get_child(0))
		
	var label_arrays = [] #array of arrays. groups of 5, 1 array for each script leaderboard entry
	var current_array = []
	for node in grid.get_children():
		current_array.append(node)
		if current_array.size() == 5:
			label_arrays.append(current_array)
			current_array = []
	# sort_custom: Depends on current sort option.
	if sort_option == SortOption.MONEY:
		button_sort.text = "Sort by: Money Earned"
		label_arrays.sort_custom(
			func(a: Array, b: Array): return int(a[1].text) - int(b[1].text) > 0
		)
	if sort_option == SortOption.SUPPORT:
		button_sort.text = "Sort by: Support Count"
		label_arrays.sort_custom(
			func(a: Array, b: Array): return int(a[2].text) - int(b[2].text) > 0
		)
	if sort_option == SortOption.STEAL:
		button_sort.text = "Sort by: Steal Count"
		label_arrays.sort_custom(
			func(a: Array, b: Array): return int(a[3].text) - int(b[3].text) > 0
		)
	if sort_option == SortOption.MATCHES:
		button_sort.text = "Sort by: Matches Played"
		label_arrays.sort_custom(
			func(a: Array, b: Array): return int(a[4].text) - int(b[4].text) > 0
		)
	for node in grid.get_children():
		grid.remove_child(node)
	for node in header_array:
		grid.add_child(node)
	for array in label_arrays:
		for node in array:
			grid.add_child(node)

func add_leaderboard_entry(name: String, points: int, support: int, steal: int, matches: int):
	var label : Label = Label.new()
	label.text = name
	grid.add_child(label)
	label = Label.new()
	label.text = str(points)
	grid.add_child(label)
	label = Label.new()
	label.text = str(support)
	grid.add_child(label)
	label = Label.new()
	label.text = str(steal)
	grid.add_child(label)
	label = Label.new()
	label.text = str(matches)
	grid.add_child(label)

func _on_button_back_pressed() -> void:
	Root.main_menu()

func _on_button_sort_pressed() -> void:
	sort_option += 1
	if sort_option == 4:
		sort_option = 0
	sort_leaderboard()

func _on_button_clear_pressed() -> void:
	clear_leaderboard_file()
	read_leaderboard_file()
	sort_leaderboard()
