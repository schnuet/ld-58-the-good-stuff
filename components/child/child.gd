extends Node2D

var player_inside = false;
@onready var requirements_bubble = $RequirementsBubble;
@onready var chocolate_requirement = $RequirementsBubble/HBoxContainer/Chocolate;
@onready var lolly_requirement = $RequirementsBubble/HBoxContainer/Lolly;
@onready var cookie_requirement = $RequirementsBubble/HBoxContainer/Cookie;
@onready var interact_marker = $InteractMarker;
@onready var player = get_tree().get_first_node_in_group("player");
var requirements_timeout = 3.0;

@onready var voices = [
	$VoiceSound1,
	$VoiceSound2,
	$VoiceSound3,
	$VoiceSound4
];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	requirements_bubble.visible = false;
	$AnimatedSprite2D.play();
	interact_marker.hide();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if requirements_bubble.visible:
		#requirements_timeout -= _delta;
		#if requirements_timeout <= 0:
			#hide_requirements_bubble();
			#requirements_timeout = 3.0;
	
	if not player_inside:
		if requirements_bubble.visible:
			hide_requirements_bubble();
			interact_marker.hide();
		return;
	
	if not requirements_bubble.visible:
		$VoiceSound5.play();
		show_requirements_bubble();
		if player.carries_chocolate or player.carries_lolly or player.carries_cookie:
			interact_marker.show();

	if Input.is_action_just_pressed("action"):
		interact();

func interact():
	
	if player == null:
		return;
	
	player.paused = true;
	
	if player.carries_chocolate:
		player.drop_sweets("chocolate", 1);
		Globals.secured_main_sweets.set("chocolate", true);
		chocolate_requirement.hide();
		interact_marker.hide();
		play_voice();
	elif player.carries_lolly:
		player.drop_sweets("lolly", 1);
		Globals.secured_main_sweets.set("lolly", true);
		lolly_requirement.hide();
		interact_marker.hide();
		play_voice();
	elif player.carries_cookie:
		player.drop_sweets("cookies", 1);
		Globals.secured_main_sweets.set("cookies", true);
		cookie_requirement.hide();
		interact_marker.hide();
		play_voice();
	else:
		interact_marker.hide();
	
	if is_game_complete():
		var fade_out_options = SceneManager.create_options(1.0, "fade", 0.1, false);
		var fade_in_options = SceneManager.create_options(1.0, "fade", 0.1, false);
		var general_options = SceneManager.create_general_options(Color.BLACK, 3.0, false, true);
		SceneManager.change_scene("SceneCredits", fade_out_options, fade_in_options, general_options);
		return;
	
	
	player.paused = false;

func is_game_complete():
	return (
		Globals.secured_main_sweets.get("cookies") and
		Globals.secured_main_sweets.get("chocolate") and
		Globals.secured_main_sweets.get("lolly")
	)

func show_requirements_bubble():
	requirements_bubble.show();

func hide_requirements_bubble():
	requirements_bubble.hide();

func play_voice():
	var max = voices.size() - 1;
	var rand = randi_range(0, max);
	var voice = voices[rand];
	voice.play();

func _on_interaction_area_area_entered(area: Area2D) -> void:
	player_inside = true;


func _on_interaction_area_area_exited(area: Area2D) -> void:
	player_inside = false;
