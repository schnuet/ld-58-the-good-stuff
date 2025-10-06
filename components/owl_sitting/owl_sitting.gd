extends Node2D

@onready var animated_sprite = $AnimatedSprite2D;
@onready var voices = [$Call1, $Call2];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play();

func play_voice():
	var max_voice = voices.size() - 1;
	var rand = randi_range(0, max_voice);
	var voice = voices[rand];
	voice.play();


func _on_call_timer_timeout() -> void:
	play_voice();
	$CallTimer.start(randi_range(3, 8));
