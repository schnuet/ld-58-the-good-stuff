extends AnimatedSprite2D


@onready var sounds = [$Sound1, $Sound2, $Sound3];
@onready var timer = $Timer;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flip_h = randi_range(0, 1) == 0;
	var variant = randi_range(1, 3);
	var anim = "tree_" + str(variant);
	frame = randi_range(1, 48);
	play(anim);
	
	timer.start(randi_range(5, 9));

func play_sound():
	var max_voice = sounds.size() - 1;
	var rand = randi_range(0, max_voice);
	var voice = sounds[rand];
	voice.play();


func _on_timer_timeout() -> void:
	play_sound();
	timer.start(randi_range(1, 6));
