extends Node2D

var player_inside = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play();


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
	
	player.paused = true;
	
	if player.carries_chocolate:
		player.drop_sweets("chocolate", 1);
		Globals.secured_main_sweets.set("chocolate", true);
	elif player.carries_lolly:
		player.drop_sweets("lolly", 1);
		Globals.secured_main_sweets.set("lolly", true);
	elif player.carries_cookie:
		player.drop_sweets("cookies", 1);
		Globals.secured_main_sweets.set("cookies", true);
	else:
		print("nothing to secure");
	
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
