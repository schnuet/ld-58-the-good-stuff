extends Control

var sweets: int = 0;
var max_sweets: int = 30;

var upgrade_level: int = 1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func add_sweets(num: int):
	update_sweets(sweets + num);

func lose_sweets(num: int):
	update_sweets(sweets - num);

func update_sweets(num: int):
	sweets = clamp(num, 0, max_sweets);
	$Label.text = str(sweets);

func upgrade():
	if upgrade_level == 1:
		upgrade_level = 2;
		max_sweets = 50;
	elif upgrade_level == 2:
		upgrade_level = 3;
		max_sweets = 80;
	elif upgrade_level == 3:
		upgrade_level = 4;
		max_sweets = 120;
