extends Node2D

@export var min_y: int = -6250;
@export var max_y: int = 6250;
@export var min_x: int = -7000;
@export var max_x: int = 7000;

@export var speed: int = 400;

var target: Vector2 = Vector2.ZERO;
var arrived: bool = true;
var dir = 1;
@onready var player = get_tree().get_first_node_in_group("player");

@onready var voices = [$Call1, $Call2];
@onready var animated_sprite = $AnimatedSprite2D;
@onready var cooldown_timer = $CooldownTimer;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true;
	animated_sprite.play();
	cooldown_timer.start(randi_range(0, 60));


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not cooldown_timer.is_stopped():
		return;
	
	if arrived:
		return;
	
	if global_position.x < min_x or global_position.x > max_x:
		arrived = true;
		cooldown_timer.start(randi_range(0, 30));
		return;
	
	global_position.x += delta * speed * dir;

func start_new_trip():
	if player == null: return;
	var player_pos = player.global_position;
	var y_start = clamp(player_pos.y - 1500, min_y, max_y);
	var y_end = clamp(player_pos.y - 1500, min_y, max_y);
	var next_y = randi_range(y_start, y_end);
	var left = randi_range(0, 1) == 0;
	if left:
		dir = 1;
		animated_sprite.flip_h = false;
		global_position = Vector2(player_pos.x - 2000, next_y);
		target = Vector2(max_x, global_position.y);
	else:
		dir = -1;
		animated_sprite.flip_h = true;
		global_position = Vector2(player_pos.x + 2000, next_y);
		target = Vector2(min_x, global_position.y);
	
	arrived = false;

func play_voice():
	var max_voice = voices.size() - 1;
	var rand = randi_range(0, max_voice);
	var voice = voices[rand];
	voice.play();


func _on_call_timer_timeout() -> void:
	play_voice();
	$CallTimer.start(randi_range(3, 8));


func _on_cooldown_timer_timeout() -> void:
	start_new_trip();
