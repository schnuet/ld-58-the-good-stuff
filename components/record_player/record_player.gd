extends Node2D

@onready var main_music = $MainMusic;
@onready var animated_sprite = $AnimatedSprite2D;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play();

func _process(delta: float) -> void:
	if not main_music.playing:
		main_music.play();
	if Input.is_action_just_pressed("action"):
		if $InteractionArea.has_overlapping_areas():
			var playback_position = main_music.get_playback_position();
			main_music.play(clamp(playback_position - 0.5, 0, 1000));
