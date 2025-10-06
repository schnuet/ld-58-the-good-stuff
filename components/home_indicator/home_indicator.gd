extends Node2D

var camera;
var player;

var home_center = Vector2(640, 360);
var screen_size = Vector2(1280, 720);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player");
		return;
	
	if camera == null:
		camera = get_tree().get_first_node_in_group("camera");
		return;

	# position itself on the edge of the camera area, indicating the home direction
	position = Vector2(640, 360);
	var dir_to_home = (home_center - player.global_position).normalized();
	var half_screen = screen_size * 0.5;
	position += Vector2(dir_to_home.x * half_screen.x, dir_to_home.y * half_screen.y) * 0.9;
	rotation = dir_to_home.angle() + PI / 2;
	
	visible = (player.global_position - home_center).length() > 600;
