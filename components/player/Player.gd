class_name Player
extends CharacterBody2D

const speed_in_camp = 300;

const LIGHT_ENERGY_MAX = 0.7;

# Movement speed in pixels per second.
@export var speed := 300
@export var friction = 0.20

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


var level = 1;

var light_on = false: set = set_light_on

var health = 3: set = set_health
var max_health = 0: set = set_max_health

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D;

#scenemanager
var icon;
var health_bar;

var sweets_bag;

func _ready():
	#icon = get_tree().get_first_node_in_group("player_icon");
	#health_bar = get_tree().get_first_node_in_group("player_healthbar");
	#
	#set_max_health(3);
	#set_health(max_health);
	
	sweets_bag = get_tree().get_first_node_in_group("sweets_bag");
	
	animated_sprite.play("stand");


func increase_level():
	var lost_health = max_health - health;
	level += 1;
	
	if level == 2:
		set_max_health(4);
	if level == 3:
		set_max_health(5);
		
	set_health(max_health - lost_health);
	print("player level increased to ", level);


func add_cold_damage(damage = 1):
	set_health(health - damage);
	print("got cold damage", health);
	
	if health <= 0:
		print("game over!");


func set_health(value):
	health = value;
	health_bar.value = value;
	
	if health <= 2:
		icon.get_node("AnimationPlayer").play("Blink");
	else:
		icon.get_node("AnimationPlayer").stop(true);

func set_max_health(value):
	max_health = value;
	health_bar.max_value = value;

func set_light_on(value):
	light_on = value;
	
	if light_on:
		$LightAnimation.play("LightPulse");
	else:
		$LightAnimation.stop();
	
	# update sprite to show the eye
	_update_sprite(x_direction);


# Movement

func _physics_process(_delta):
	
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
	
	# Using the follow steering behavior.
	var target_velocity = direction * speed
	_velocity += (target_velocity - _velocity) * friction
	set_velocity(_velocity)
	move_and_slide()
	_velocity = velocity
	
	var anim;
	
	if abs(_velocity.x) > 1 or abs(_velocity.y) > 1:
		anim = "walk";
	else:
		anim = "stand";
	
	if light_on:
		animated_sprite.animation = anim + "_eye";
	else:
		animated_sprite.animation = anim;


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
		animated_sprite.flip_h = false;
	if direction == Vector2.LEFT:
		x_direction = Vector2.LEFT;
		animated_sprite.flip_h = true;


func add_sweet(type: String, amount: int = 1):
	var sweets_bar = get_tree().get_first_node_in_group("sweets_bar");
	sweets_bar.show_sweet(type);
	if type == "standard":
		sweets_bag.add_sweets(amount);
		print("player add sweets ", type, " ", amount);
	elif type == "chocolate":
		Globals.collected_main_sweets.append("chocolate");
	elif type == "lolly":
		Globals.collected_main_sweets.append("lolly");
	elif type == "cookies":
		Globals.collected_main_sweets.append("cookies");
		

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
