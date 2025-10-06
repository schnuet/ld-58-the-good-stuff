extends Node2D

var player_inside = false;
var sweet_type = "standard";
var empty = false;

var variant: String = "1";
@onready var sweets_amount = randi_range(5, 10);

@onready var animated_sprite = $Graphics/AnimatedSprite2D;
@onready var graphics_node = $Graphics;
@onready var sweets_bag = get_tree().get_first_node_in_group("sweets_bag");
@onready var player = get_tree().get_first_node_in_group("player");

func _ready() -> void:
	variant = str(randi_range(1, 4));
	animated_sprite.animation = str(variant) + "_hell";

func _process(delta: float) -> void:
	if player != null:
		var vertical_difference = global_position.y - player.global_position.y;
		# scale house up if player above it, down if below
		var scale_factor = 1.0 + (vertical_difference / 3000.0);
		scale_factor = clamp(scale_factor, 0.75, 1.25);
		graphics_node.scale = Vector2(scale_factor, scale_factor);
	
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
	
	$DoorOpen.play();
	
	Globals.collected_houses.append(self)
	Globals.collected_houses_in_run.append(self);
	
	var player = get_tree().get_first_node_in_group("player");
	
	if sweet_type == "standard":
		player.add_sweet("standard", sweets_amount);
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
	if sweets_bag.sweets >= sweets_bag.max_sweets:
		# Play decline animation
		# TODO
		return false;
	return true;
	
func close_house():
	print("close house");
	animated_sprite.animation = str(variant) + "_dunkel";
	empty = true;
	$DoorClose.play();

func reopen():
	print("reopen house");
	sweets_amount = 10;
	animated_sprite.animation = str(variant) + "_hell";
	empty = false;

func make_special():
	variant = "good-stuff-" + str(1);
	animated_sprite.animation = str(variant) + "_hell";

func _on_interaction_area_area_entered(area: Area2D) -> void:
	player_inside = true;


func _on_interaction_area_area_exited(area: Area2D) -> void:
	player_inside = false;
