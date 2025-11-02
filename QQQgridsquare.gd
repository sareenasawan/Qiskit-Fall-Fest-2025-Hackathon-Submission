extends ColorRect

@onready var label = $Label
var goodtogo = false

@export var percentage: int = 50:
	set(value):
		percentage = clamp(value, 0, 100)
		if goodtogo:
			_update_visuals()
			
var value: int = 0  # 0 or 1, for logical collapse state
var collapsed: bool = false  # new flag

func _ready():
	goodtogo = true
	_update_visuals()

func _update_visuals():
	if collapsed:
		# After collapse: show 0/1 and pure color
		label.text = str(value)
		if value == 1:
			color = Color(1,0,0)  # Red
		else:
			color = Color(0,0,1)  # Blue
	else:
		label.text = str(percentage) + "%"
		var t = float(percentage) / 100.0
		
		# Shift faster from 0.5 toward extremes
		if t < 0.5:
			t = pow(t * 2, 4) / 2          # 0 → 0.5, blue → purple
		else:
			t = 1 - pow((1 - t) * 2, 4) / 2  # 0.5 → 1, purple → red
		
		color = Color(t, 0, 1 - t)
