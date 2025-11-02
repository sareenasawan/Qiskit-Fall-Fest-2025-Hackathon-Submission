extends Control

@onready var turn_bg = $TurnBackground
@onready var main_grid = $MainGrid
@onready var collapse = $collapse
@onready var func_buttons = $FunctionOptions.get_children()  # 3 function buttons

@onready var turn_label = $TurnLabel
@onready var win_label = $highlight/winLabel

var player_turn = 0  # 0 = red, 1 = blue

# Define your function maps for each player
# Red player benefits from positive values
var red_maps = [
	[10, 5, -5, 0, 5, 0, -5, 5, 0],
	[5, 0, 5, 0, 10, 0, -5, -5, 0],
	[5, 0, 5, 0, 5, 0, -5, -5, 5],
	[10, 0, -5, 5, 0, 5, -5, 0, 10],
	[-5, 0, 5, 0, 15, 0, 5, 0, -5],
	[5, -5, 5, -5, 5, -5, 5, -5, 5],
	[15, -5, 0, 5, 0, -5, 0, 5, 0],
	[-5, 0, 10, 0, 0, 0, 5, 0, -5],
	[5, 5, 5, -5, 0, -5, 5, 5, 5],
	[5, -5, 5, 0, 10, 0, 5, -5, 5],
	[5, 0, 5, 5, -5, 0, 0, 0, 10],
	[-5, 5, -5, 5, 10, 5, -5, 5, -5],
	[10, -5, 10, -5, 0, -5, 10, -5, 10],
	[0, 5, 0, 10, -5, 10, 0, 5, 0],
	[10, 0, -5, 0, 5, 0, -5, 0, 10],
	[10, -5, -5, 0, 10, 0, -5, -5, 10],
	[5, 0, 0, 5, 5, 5, 0, 0, 5],
	[5, 5, -5, -5, 15, -5, -5, 5, 5],
	[-5, 10, -5, 10, 0, 10, -5, 10, -5],
	[0, -5, 10, 5, 0, 5, 10, -5, 0]
]


# Blue player benefits from negative values
var blue_maps = [
	[-10, -5, 5, 0, -5, 0, 5, -5, 0],
	[-5, 0, -5, 0, -10, 0, 5, 5, 0],
	[-5, 0, -5, 0, -5, 0, 5, 5, -5],
	[-10, 0, 5, -5, 0, -5, 5, 0, -10],
	[5, 0, -5, 0, -15, 0, -5, 0, 5],
	[-5, 5, -5, 5, -5, 5, -5, 5, -5],
	[-15, 5, 0, -5, 0, 5, 0, -5, 0],
	[5, 0, -10, 0, 0, 0, -5, 0, 5],
	[-5, -5, -5, 5, 0, 5, -5, -5, -5],
	[-5, 5, -5, 0, -10, 0, -5, 5, -5],
	[-5, 0, -5, -5, 5, 0, 0, 0, -10],
	[5, -5, 5, -5, -10, -5, 5, -5, 5],
	[-10, 5, -10, 5, 0, 5, -10, 5, -10],
	[0, -5, 0, -10, 5, -10, 0, -5, 0],
	[-10, 0, 5, 0, -5, 0, 5, 0, -10],
	[-10, 5, 5, 0, -10, 0, 5, 5, -10],
	[-5, 0, 0, -5, -5, -5, 0, 0, -5],
	[-5, -5, 5, 5, -15, 5, 5, -5, -5],
	[5, -10, 5, -10, 0, -10, 5, -10, 5],
	[0, 5, -10, -5, 0, -5, -10, 5, 0]
]

func _ready():
	# Connect button signals
	for i in range(func_buttons.size()):
		var option_button = func_buttons[i]
		if option_button is option:
			option_button.pressed.connect(_on_function_selected.bind(i))
	# Setup first turn
	
	# Connect collapse button
	collapse.pressed.connect(_on_collapse_pressed)
	
	
	_setup_turn()

func _on_function_selected(index):
	# Get the clicked Option
	var selected_option = func_buttons[index]

	# Apply its func_map to the main grid
	for i in range(3):
		for j in range(3):
			var cell_name = "%d_%d" % [i, j]
			var cell = main_grid.get_node(cell_name)
			var map_index = i * 3 + j
			# Apply depending on player_turn
			if player_turn == 0:
				cell.percentage += selected_option.func_map[map_index]
			else:
				cell.percentage += selected_option.func_map[map_index]  # blue maps already negative
			# QQQSelectSquare setter clamps 0-100 and updates color

	# Switch player turn
	player_turn = 1 - player_turn

	# Setup next turn
	_setup_turn()

func _setup_turn():
	# Example: pick 3 new random functions per player
	var pool = []
	if player_turn == 0:
		pool = red_maps
	else:
		pool = blue_maps
	pool.shuffle()
	for i in range(func_buttons.size()):
		var option_button = func_buttons[i]
		if option_button.has_method("set_func_map"):
			option_button.set_func_map(pool[i])
	# Update any turn indicator UI
	$TurnLabel.text = "Player %d’s Turn (%s)" % [player_turn, "Red" if player_turn == 0 else "Blue"]
	var new_color: Color
	var enter_from_left: bool

	# Determine color and slide direction
	if player_turn == 0:
		new_color = Color(1, 0.2, 0.2, 0.8)  # red
		enter_from_left = true
	else:
		new_color = Color(0.2, 0.2, 1, 0.8)  # blue
		enter_from_left = false

	var screen_width = get_viewport_rect().size.x
	var y_pos = turn_bg.position.y

	# Define positions
	var enter_x = -turn_bg.size.x if enter_from_left else screen_width
	var center_x = 0.0
	var exit_x = screen_width if enter_from_left else -turn_bg.size.x

	# If a color is already visible, make it slide out
	if turn_bg.visible:
		var exit_tween = create_tween()
		exit_tween.tween_property(turn_bg, "position:x", exit_x, 0.4)
		exit_tween.tween_callback(func ():
			# After sliding out, reappear with new color from opposite side
			turn_bg.color = new_color
			turn_bg.position.x = enter_x
			var enter_tween = create_tween()
			enter_tween.tween_property(turn_bg, "position:x", center_x, 0.4)
			enter_tween.set_trans(Tween.TRANS_SINE)
			enter_tween.set_ease(Tween.EASE_OUT)
		)
	else:
		# On first turn setup
		turn_bg.visible = true
		turn_bg.color = new_color
		turn_bg.position.x = enter_x
		var first_tween = create_tween()
		first_tween.tween_property(turn_bg, "position:x", center_x, 0.4)
		first_tween.set_trans(Tween.TRANS_SINE)
		first_tween.set_ease(Tween.EASE_OUT)

func _on_collapse_pressed():
	var board = []  # 2D array to store collapsed values
	
	for i in range(3):
		var row = []
		for j in range(3):
			var cell_name = "%d_%d" % [i, j]
			var cell = main_grid.get_node(cell_name)
			
			# Collapse to 1 (Red) or 0 (Blue)
			var value = randi() % 2
			row.append(value)
			cell.value = value
			cell.collapsed = true
			cell._update_visuals()
			
			# Update visual
			cell.percentage = value * 100  # optional: for coloring with current system
		board.append(row)
	
	# Check for winner
	var winner = get_tic_tac_toe_winner(board)
	
	match winner:
		1:
			win_label.text = "Collapse Result: Red wins!"
		0:
			win_label.text = "Collapse Result: Blue wins!"
		-1:
			win_label.text = "Collapse Result: Draw!"
	
	# Disable buttons
	for button in func_buttons:
		button.disabled = true
	$collapse.disabled = true
	$highlight.visible = true
	
	highlight_winning_lines()
	
func get_tic_tac_toe_winner(board):
	var winning_lines := []
	var winner := -1
	
	# Check rows and columns
	for i in range(3):
		# Row
		if board[i][0] != -1 and board[i][0] == board[i][1] and board[i][1] == board[i][2]:
			winning_lines.append([board[i][0], [i,0],[i,1],[i,2]])
		# Column
		if board[0][i] != -1 and board[0][i] == board[1][i] and board[1][i] == board[2][i]:
			winning_lines.append([board[0][i], [0,i],[1,i],[2,i]])
	
	# Check diagonals
	if board[0][0] != -1 and board[0][0] == board[1][1] and board[1][1] == board[2][2]:
		winning_lines.append([board[0][0], [0,0],[1,1],[2,2]])
	if board[0][2] != -1 and board[0][2] == board[1][1] and board[1][1] == board[2][0]:
		winning_lines.append([board[0][2], [0,2],[1,1],[2,0]])
	
	if winning_lines.size() == 0:
		return -1  # No winner

	# Determine winner consistency
	winner = winning_lines[0][0]
	for line in winning_lines:
		if line[0] != winner:
			# Conflict: two lines with different values → draw
			return -1

	# All winning lines are the same player
	return winner


func get_board_values() -> Array:
	var grid = []
	for cell in main_grid.get_children():
		grid.append(cell.value)  # whatever variable stores 0 or 1
	return grid
	
func highlight_winning_lines():
	var grid = get_board_values()

	# index patterns for 3x3 tic tac toe
	var lines = [
		[0, 1, 2], [3, 4, 5], [6, 7, 8],  # rows
		[0, 3, 6], [1, 4, 7], [2, 5, 8],  # columns
		[0, 4, 8], [2, 4, 6]              # diagonals
	]

	for line in lines:
		var a = grid[line[0]]
		var b = grid[line[1]]
		var c = grid[line[2]]

		# skip uncollapsed or mixed lines
		if a == null or b == null or c == null:
			continue
		if a == b and b == c:
			_flash_line(line, a)
			
func _flash_line(line: Array, value: int):
	for idx in line:
		var cell = main_grid.get_child(idx)
		var target_color = Color(0.2, 0.2, 1)
		if value == 1:
			target_color = Color(1, 0.2, 0.2)
		var tween = create_tween()
		tween.tween_property(cell, "color", target_color, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(cell, "modulate", Color(1,1,1,0.6), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(cell, "modulate", Color(1,1,1,1), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _on_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

