class_name Player
extends CharacterBody2D

const speed_in_camp = 300;

const LIGHT_ENERGY_MAX = 0.7;

# Movement speed in pixels per second.
@export var speed := 300
@export var friction = 0.20

var level = 1;
var extra_speed_factor_per_level = 0.25;

var available_interact_objects = [];

# We map a direction to a frame index of our AnimatedSprite node's sprite frames.
# See how we use it below to update the character's look direction in the game.
var _velocity := Vector2.ZERO
var _animations := {
	Vector2.RIGHT: "right",
	Vector2.LEFT: "left",
	Vector2.UP: "up",
	Vector2.DOWN: "down"
}

var x_direction = Vector2.RIGHT;
var y_direction = Vector2.DOWN;

var paused = false;

var light_on = false: set = set_light_on

var darkness_rising = false;
var returning = false;
var lose_timeout: float = 1;

var carries_chocolate = false;
var carries_lolly = false;
var carries_cookie = false;

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D;
@onready var light = $PointLight2D;
@onready var effects_layer = get_tree().get_first_node_in_group("effects_layer");

#scenemanager
var icon;
var health_bar;

@onready var sweets_bag = get_tree().get_first_node_in_group("sweets_bag");
@onready var lamp = get_tree().get_first_node_in_group("battery_lamp");
@onready var battery_light = get_tree().get_first_node_in_group("battery_light");
@onready var sweat = $AnimatedSprite2D/Sweat;

func _ready():
	#icon = get_tree().get_first_node_in_group("player_icon");
	#health_bar = get_tree().get_first_node_in_group("player_healthbar");
	#
	#set_max_health(3);
	#set_health(max_health);
	sweat.hide();
	
	animated_sprite.play("stand");


# Movement

func _physics_process(delta):
	
	if lamp != null:
		if lamp.value <= 0.0:
			if returning:
				return;
			if !darkness_rising:
				start_rising_darkness();
			if lose_timeout <= 0:
				lose_sweets();
			lose_timeout -= delta;
		else:
			var lamp_fill = lamp.value / lamp.max_value;
			var lamp_scale = 1 + lamp_fill * 2;
			light.energy = lamp_fill * 0.6 + 0.4;
			light.texture_scale = lamp_scale;
			
			if lamp_fill < 0.3:
				sweat.show();
				sweat.play();
			else:
				sweat.hide();
	
	if not paused:
		# Once again, we call `Input.get_action_strength()` to support analog movement.
		var direction := Vector2(
			# This first line calculates the X direction, the vector's first component.
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			# And here, we calculate the Y direction. Note that the Y-axis points 
			# DOWN in games.
			# That is to say, a Y value of `1.0` points downward.
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		
		# When aiming the joystick diagonally, the direction vector can have a length 
		# greater than 1.0, making the character move faster than our maximum expected
		# speed. When that happens, we limit the vector's length to ensure the player 
		# can't go beyond the maximum speed.
		if direction.length() > 1.0:
			direction = direction.normalized()
		
		var upgraded_speed = speed + speed * (extra_speed_factor_per_level * (level - 1));
		# Using the follow steering behavior.
		var target_velocity = direction * upgraded_speed
		_velocity += (target_velocity - _velocity) * friction
		set_velocity(_velocity)
		move_and_slide()
	else:
		velocity = Vector2.ZERO
	
	_velocity = velocity

	# Update the character's sprite animation based on movement and light status.

	var anim: String;
	
	if abs(_velocity.x) > 3 or abs(_velocity.y) > 3:
		anim = "walk";
	else:
		anim = "stand";
		
	if anim == "walk":
		if not $WalkSoundConcrete.is_playing():
			$WalkSoundConcrete.play();
	else:
		if $WalkSoundConcrete.is_playing():
			$WalkSoundConcrete.stop();
	
	animated_sprite.animation = anim;



func enter_hub():
	print("enter hub");
	lamp.value += 0.25;
	darkness_rising = false;
	if lamp:
		lamp.enter_hub();
	else:
		print("no lamp found");

func exit_hub():
	print("exit hub");
	if lamp:
		lamp.exit_hub();
	else:
		print("no lamp found");


func start_rising_darkness():
	print("start rising darkness");
	darkness_rising = true;
	lose_timeout = 1;
	var tween = get_tree().create_tween();
	tween.tween_property(battery_light.local_light, "energy", 0, 0.2);
	tween.tween_property(battery_light.local_light, "texture_scale", 0, 0.2);
	await tween.finished;
	print("end rising darkness");


func lose_sweets():
	# get sweets stolen by darkness
	if sweets_bag.sweets <= 0:
		paused = true;
		$LoseSound.play();
		respawn_in_hub();
		return;
	sweets_bag.lose_sweets(10);
	$LoseSound.play();
	var house = Globals.collected_houses_in_run.pop_back();
	if house != null and not house.is_special:
		house.reopen();
	lose_timeout = 1.5;

func respawn_in_hub():
	print("start respawn");
	paused = true;
	returning = true;
	animated_sprite.animation = "stand";
	global_position = Vector2(640, 460);
	var camera = get_tree().get_first_node_in_group("camera");
	camera.global_position = Vector2(640, 300);
	darkness_rising = false;
	await get_tree().create_timer(0.5).timeout;
	returning = false;
	var tween = get_tree().create_tween();
	tween.tween_property(lamp, "value", lamp.max_value, 1);
	await get_tree().create_timer(3).timeout;
	paused = false;
	return;


func upgrade():
	level += 1;


func set_light_on(value):
	light_on = value;
	
	if light_on:
		$LightAnimation.play("LightPulse");
	else:
		$LightAnimation.stop();
	
	# update sprite to show the eye
	_update_sprite(x_direction);


# The code below updates the character's sprite to look in a specific direction.
func _unhandled_input(event):
	if event.is_action_pressed("right"):
		_update_sprite(Vector2.RIGHT)
	elif event.is_action_pressed("left"):
		_update_sprite(Vector2.LEFT)
	elif event.is_action_pressed("down"):
		_update_sprite(Vector2.DOWN)
	elif event.is_action_pressed("up"):
		_update_sprite(Vector2.UP)

	if event.is_action_pressed("action"):
		interact_with_object();
		

func _update_sprite(direction: Vector2) -> void:
	if direction == Vector2.DOWN:
		y_direction = Vector2.DOWN;
	elif direction == Vector2.UP:
		y_direction = Vector2.UP;
	
	if direction == Vector2.RIGHT:
		x_direction = Vector2.RIGHT;
		animated_sprite.scale.x = 1;
	if direction == Vector2.LEFT:
		x_direction = Vector2.LEFT;
		animated_sprite.scale.x = -1;


func add_sweet(type: String, amount: int = 1):
	var sweets_bar = get_tree().get_first_node_in_group("sweets_bar");
	if type == "standard":
		paused = true;
		$CollectSound.play();
		await effects_layer.play_effect("collect_bad_sweets", global_position - Vector2(0, 210));
		paused = false;
		sweets_bag.add_sweets(amount);
		print("player add sweets ", type, " ", amount);
	elif type == "chocolate":
		$GoodCollectSound.play();
		await effects_layer.play_effect("collect_chocolate", global_position - Vector2(0, 210));
		carries_chocolate = true;
		sweets_bar.show_sweet("chocolate");
	elif type == "lolly":
		$GoodCollectSound.play();
		await effects_layer.play_effect("collect_lolly", global_position - Vector2(0, 210));
		carries_lolly = true;
		sweets_bar.show_sweet("lolly");
	elif type == "cookies":
		$GoodCollectSound.play();
		await effects_layer.play_effect("collect_cookie", global_position - Vector2(0, 210));
		carries_cookie = true;
		sweets_bar.show_sweet("cookies");

func drop_sweets(type: String, amount: int = 1):
	print("drop ", type, " -- ", amount);
	var sweets_bar = get_tree().get_first_node_in_group("sweets_bar");
	sweets_bar.hide_sweet(type);
	if type == "standard":
		sweets_bag.lose_sweets(amount);
		print("player lose sweets ", type, " ", amount);
	elif type == "chocolate":
		carries_chocolate = false;
	elif type == "lolly":
		carries_lolly = false;
	elif type == "cookies":
		carries_cookie = false;
		

func interact_with_object():
	if available_interact_objects.size() == 0:
		return;
	
	available_interact_objects[0].interact(self);

func _on_InteractArea2D_body_entered(body:Node2D):
	if body.disabled:
		return;
	
	available_interact_objects.push_back(body);
	
	if body.has_method("_on_enter_range"):
		body._on_enter_range();


func _on_InteractArea2D_body_exited(body):
	available_interact_objects.erase(body)
	
	if body.has_method("_on_leave_range"):
		body._on_leave_range();
