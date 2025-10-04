extends Node2D

var player_inside = false;
var sweet_type = "standard";
var empty = false;

func _process(delta: float) -> void:
	if not player_inside:
		return
	
	if empty:
		return;
	
	if Input.is_action_just_pressed("action"):
		give_sweet();

func give_sweet():
	if empty:
		return;

	if not check_if_player_has_space():
		print("player has no space");
		return false;
	
	var id = get_instance_id();
	var collected_houses_count = Globals.collected_houses.size();
	if collected_houses_count == 0:
		sweet_type = "standard";
	elif collected_houses_count % 30 == 0:
		sweet_type = "chocolate";
	elif collected_houses_count % 20 == 0:
		sweet_type = "lolly";
	elif collected_houses_count % 10 == 0:
		sweet_type = "cookies";
		
	print("sweet type ", sweet_type);
	
	Globals.collected_houses.append(id)
	Globals.collected_houses_in_run.append(id);
	
	var player = get_tree().get_first_node_in_group("player");
	
	if sweet_type == "standard":
		player.add_sweet("standard", randi_range(5, 10));
	elif sweet_type == "chocolate":
		player.add_sweet("chocolate", 1);
	elif sweet_type == "lolly":
		player.add_sweet("lolly", 1);
	elif sweet_type == "cookies":
		player.add_sweet("cookies", 1);
	
	close_house();

	return;

func check_if_player_has_space():
	# Check if the player has space in their bag.
	# If not, play a short decline animation.
	return true;
	
func close_house():
	print("close house")
	empty = true;

func _on_interaction_area_area_entered(area: Area2D) -> void:
	player_inside = true;


func _on_interaction_area_area_exited(area: Area2D) -> void:
	player_inside = false;
