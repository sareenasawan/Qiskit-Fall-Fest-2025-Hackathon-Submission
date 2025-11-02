extends ColorRect

@export var value: int = 0:
	set(v):
		value = v
		if goodtogo:
			_update_visual()
var goodtogo = false

@onready var label = $Label

func _ready():
	goodtogo = true
	_update_visual()

func _update_visual():
	# Purely visual — red for +, blue for -, gray for 0
	if value > 0:
		color = Color(1, 0, 0)
	elif value < 0:
		color = Color(0, 0, 1)
	else:
		color = Color(0.15, 0.15, 0.15)

	# Show numeric value for clarity
	label.text = (("+" if value > 0 else "-" if value < 0 else "0") + str(abs(value)))
	label.add_theme_color_override("font_color", Color(1, 1, 1))
