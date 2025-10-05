extends Area2D

var player_inside = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	print("player area entered");
	player_inside = true;
	var player = get_player();
	if player:
		player.enter_hub();

func _on_area_exited(area: Area2D) -> void:
	print("player area exited");
	player_inside = false;
	var player = get_player();
	if player:
		player.exit_hub();

func get_player():
	return get_tree().get_first_node_in_group("player");
