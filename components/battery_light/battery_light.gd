extends Control

@onready var animated_sprite = $LightAnimatedSprite;
@onready var light_shine_sprite = $LightShineSprite;
@onready var local_light = $PointLight2D;
@onready var lamp = get_tree().get_first_node_in_group("battery_lamp");
@onready var player = get_tree().get_first_node_in_group("player");

var base_scale = 0.05;
var extra_scale = 0.95;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play();
	light_shine_sprite.play();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# var camera = get_camera();
	if player == null:
		return;
	
	# Update light by animation
	#local_light.texture = light_shine_sprite.sprite_frames.get_frame_texture("shine", light_shine_sprite.frame);
	
	global_position = player.global_position - Vector2(0, 96);
	
	if player.darkness_rising:
		return;
	if player.returning:
		return;
	
	var percent_loaded = lamp.value / lamp.max_value;
	light_shine_sprite.speed_scale = 0.5 + (1 - percent_loaded) * 0.75;
	animated_sprite.speed_scale = 0.5 + (1 - percent_loaded) * 0.75;

	var light_scale = base_scale + extra_scale * percent_loaded * percent_loaded;
	animated_sprite.scale = Vector2(light_scale, light_scale);
	
	local_light.energy = percent_loaded * 0.6 + 0.4;
	local_light.texture_scale = light_scale;
	
	if percent_loaded > 0.97:
		local_light.texture_scale = 3;
	
	var light = player.light;
	light.energy = 0;
	#light.energy = percent_loaded * 0.6 + 0.4;
	#light.texture_scale = light_scale;


func upgrade():
	base_scale *= 1.2;
	extra_scale *= 1.25;

func get_player():
	return get_tree().get_first_node_in_group("player");

func get_camera():
	return get_tree().get_first_node_in_group("camera");
