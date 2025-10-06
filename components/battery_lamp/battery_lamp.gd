extends Control

var in_hub = true;
var max_value = 30.0;
var value = max_value;

var level = 1;

@onready var player = get_tree().get_first_node_in_group("player");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null:
		return;

	if player.returning:
		return;

	if in_hub:
		value += delta * 10.0;
	else:
		value -= delta * 1.0;

	value = clamp(value, 0.0, max_value);
	$ProgressBar.value = value / max_value * 100.0;

func enter_hub():
	print("lamp enter hub");
	in_hub = true;

func exit_hub():
	print("lamp exit hub");
	in_hub = false;

func upgrade():
	max_value += 10;
