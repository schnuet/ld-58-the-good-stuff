extends Control

var sweets: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func add_sweets(num: int):
	update_sweets(sweets + num);

func lose_sweets(num: int):
	update_sweets(sweets - num);

func update_sweets(num: int):
	sweets = num;
	$Label.text = str(sweets);
