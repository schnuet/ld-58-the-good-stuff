extends Node2D

@onready var animated_sprite = $AnimatedSprite2D;
@onready var player: Node2D = get_tree().get_first_node_in_group("player");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player.global_position.distance_to(global_position) < 400:
		if visible:
			hide();
			$HideSound.play();
		return;
	
	if not visible:
		if randi() % 300 == 0:
			$HideSound.play();
			show();


func _on_timer_timeout() -> void:
	if not $HideSound.playing:
		$MoveSound.play();
	$Timer.start(randi_range(10, 20));
