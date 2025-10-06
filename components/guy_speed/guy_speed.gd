extends Node2D

var player_inside = false;
var sweets_cost = 20;
var bought_out = false;

@onready var sweets_bag = get_tree().get_first_node_in_group("sweets_bag");
@onready var effects_layer = get_tree().get_first_node_in_group("effects_layer");
@onready var requirements_bubble = $RequirementsBubble;
@onready var idle_timer = $Timer;
@onready var animated_sprite = $AnimatedSprite2D;
@onready var interact_marker = $InteractMarker;

@onready var voices = [$VoiceSound1, $VoiceSound2];

var requirements_timeout = 3.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	requirements_bubble.visible = false;
	interact_marker.hide();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if bought_out:
		if requirements_bubble.visible:
			interact_marker.hide();
			hide_requirements_bubble();
		return;
	#if requirements_bubble.visible:
		#requirements_timeout -= _delta;
		#if requirements_timeout <= 0:
			#hide_requirements_bubble();
			#requirements_timeout = 3.0;
	
	if not player_inside:
		if requirements_bubble.visible:
			interact_marker.hide();
			hide_requirements_bubble();
		return;
	
	if not requirements_bubble.visible:
		play_voice();
		if sweets_bag.sweets >= sweets_cost:
			interact_marker.show();
		show_requirements_bubble();

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
		animated_sprite.play("buy");
		player.drop_sweets("standard", sweets_cost);
		player.upgrade();
		$BuySound.play();
		await effects_layer.play_effect("speed_upgrade", global_position);
		update_sweets_cost(sweets_cost * 1.5);
		if player.level >= 3:
			bought_out = true;
		await get_tree().create_timer(0.3).timeout;
		play_voice();
	else:
		pass
	
	player.paused = false;

func is_game_complete():
	return (
		Globals.secured_main_sweets.get("cookies") and
		Globals.secured_main_sweets.get("chocolate") and
		Globals.secured_main_sweets.get("lolly")
	)

func update_sweets_cost(new_cost: int):
	sweets_cost = new_cost;
	var sweets_label = requirements_bubble.get_node("sweets");
	sweets_label.text = str(sweets_cost);

func show_requirements_bubble():
	print("needs sweets: ", sweets_cost);
	requirements_bubble.show();

func hide_requirements_bubble():
	requirements_bubble.hide();

func _on_interaction_area_area_entered(area: Area2D) -> void:
	player_inside = true;


func _on_interaction_area_area_exited(area: Area2D) -> void:
	player_inside = false;

func play_voice():
	var max = voices.size() - 1;
	var rand = randi_range(0, max);
	var voice = voices[rand];
	voice.play();

func _on_timer_timeout() -> void:
	if not animated_sprite.is_playing():
		animated_sprite.play("idle");
	idle_timer.start(randi_range(2, 5));
