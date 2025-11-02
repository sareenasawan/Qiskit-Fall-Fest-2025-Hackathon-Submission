extends Button
class_name option

@export var func_map: Array = []  # no <int> constraint

func set_func_map(map: Array) -> void:
	func_map = map
	_update_grid()
	
@onready var grid = $GridContainer  # your 3x3 container

func _ready():
	_update_grid()

func _update_grid():
	# Make sure func_map has 9 values
	if func_map.size() != 9:
		push_error("func_map must have 9 values!")
		return

	for i in range(3):
		for j in range(3):
			var cell_name = "%d_%d" % [i, j]
			var cell = grid.get_node(cell_name)  # get the square by name
			var index = i * 3 + j              # convert 2D coords to linear index
			cell.value = func_map[index]       # set the value, triggers color update

