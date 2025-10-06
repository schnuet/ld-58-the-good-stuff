extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flip_h = randi_range(0, 1) == 0;
	var variant = randi_range(1, 3);
	var anim = "tree_" + str(variant);
	frame = randi_range(1, 48);
	play(anim);
