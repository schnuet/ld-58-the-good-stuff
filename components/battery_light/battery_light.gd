extends Control

@onready var animated_sprite = $LightAnimatedSprite;
@onready var lamp = get_tree().get_first_node_in_group("battery_lamp");
@onready var player = get_tree().get_first_node_in_group("player");

var base_scale = 0.25;
var extra_scale = 1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# var camera = get_camera();
	if player == null:
		return;
	
	global_position = player.global_position - Vector2(0, 96);
	
	var percent_loaded = lamp.value / lamp.max_value;
	animated_sprite.speed_scale = 0.5 + (1 - percent_loaded) * 0.75;
	var scale = base_scale + extra_scale * percent_loaded;
	animated_sprite.scale = Vector2(scale, scale);
	
	if player.darkness_rising:
		return;
	if player.returning:
		return;
	
	var light = player.light;
	light.energy = percent_loaded * 0.6 + 0.4;
	light.texture_scale = scale;


func upgrade():
	base_scale *= 1.2;
	extra_scale *= 1.25;

func get_player():
	return get_tree().get_first_node_in_group("player");

func get_camera():
	return get_tree().get_first_node_in_group("camera");
