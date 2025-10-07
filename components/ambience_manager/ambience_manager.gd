extends Node2D

@onready var battery_lamp = get_tree().get_first_node_in_group("battery_lamp");

@onready var timer_flap = $TimerFlap;
@onready var timer_bush = $TimerBush;
@onready var timer_wind = $TimerWind;
@onready var timer_walk = $TimerWalk;

@onready var wind_sounds = [$SoundWind1, $SoundWind2];
@onready var flap_sounds = [$SoundFlap1, $SoundFlap2, $SoundFlap3];
@onready var bush_sounds = [$SoundBush2, $SoundBush3, $SoundBush4];
@onready var walk_sounds = [$SoundWalk];

@onready var loop_wind = $LoopWind;

var f: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_bush.start(randi_range(10, 20));
	timer_flap.start(randi_range(10, 20));
	timer_wind.start(randi_range(10, 20));

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	f = (f+1) % 5;
	if f != 0:
		return;
	if not loop_wind.playing:
		loop_wind.play();
	loop_wind.volume_db = (get_light_percent() * -60) - 10;

func get_light_percent():
	return battery_lamp.value / battery_lamp.max_value;

func play_wind():
	var max_voice = wind_sounds.size() - 1;
	var rand = randi_range(0, max_voice);
	var sound = wind_sounds[rand];
	sound.play();

func play_flap():
	var max_voice = flap_sounds.size() - 1;
	var rand = randi_range(0, max_voice);
	var sound = flap_sounds[rand];
	sound.play();

func play_bush():
	var max_sound_index = bush_sounds.size() - 1;
	var rand = randi_range(0, max_sound_index);
	var sound = bush_sounds[rand];
	sound.play();

func play_walk():
	var max_voice = walk_sounds.size() - 1;
	var rand = randi_range(0, max_voice);
	var sound = walk_sounds[rand];
	sound.play();

# ====================

func _on_timer_wind_timeout() -> void:
	var light_percent = get_light_percent();
	if light_percent < 0.8:
		play_wind();
	timer_wind.start(1 + randi_range(4, 10) * light_percent);


func _on_timer_bush_timeout() -> void:
	var light_percent = get_light_percent();
	if light_percent < 0.8:
		play_bush();
	timer_bush.start(1 + randi_range(5, 20) * light_percent);


func _on_timer_flap_timeout() -> void:
	var light_percent = get_light_percent();
	if light_percent < 0.8:
		play_flap();
	timer_flap.start(1 + randi_range(5, 20) * light_percent);


func _on_timer_walk_timeout() -> void:
	var light_percent = get_light_percent();
	if light_percent < 0.8:
		play_walk();
	timer_walk.start(1 + randi_range(10, 20) * light_percent);
