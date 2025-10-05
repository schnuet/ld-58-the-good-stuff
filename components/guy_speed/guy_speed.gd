extends Node2D

var player_inside = false;

var sweets_cost = 20;

@onready var sweets_bag = get_tree().get_first_node_in_group("sweets_bag");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not player_inside:
		return;

	if Input.is_action_just_pressed("action"):
		interact();

func interact():
	var player = get_tree().get_first_node_in_group("player");
	if player == null:
		return;
	
	if player.level >= 3:
		return;
	
	player.paused = true;
	
	if sweets_bag.sweets >= sweets_cost:
		player.drop_sweets("standard", sweets_cost);
		player.upgrade();
		sweets_cost *= 1.5;
	else:
		print("not enough sweets -- ", sweets_cost);
	
	if is_game_complete():
		SceneManager.change_scene("res://scenes/04_win/SceneWin.tscn");
		return;
	
	player.paused = false;

func is_game_complete():
	return (
		Globals.secured_main_sweets.get("cookies") and
		Globals.secured_main_sweets.get("chocolate") and
		Globals.secured_main_sweets.get("lolly")
	)


func _on_interaction_area_area_entered(area: Area2D) -> void:
	player_inside = true;


func _on_interaction_area_area_exited(area: Area2D) -> void:
	player_inside = false;
