extends Camera2D

var player;

const room_height = 720;
var game_height = 4 * room_height;

const Y_OFFSET = -50;

func _process(_delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player");
		return;
	
	var target_x = global_position.x;
	var target_y = global_position.y;
	
	var player_position = player.global_position;
	var future_player_position = player_position + player.velocity * 0.75;

	var target_position = Vector2(future_player_position.x, future_player_position.y + Y_OFFSET);

	if player_position.x > 300 and player_position.x < 900 and player_position.y > 200 and player_position.y < 520:
		target_position.x = 640;
		target_position.y = 360;
	
	# smooth follow
	var delta = get_process_delta_time();
	var position_smoothing_speed = 5;
	if global_position != target_position:
		global_position += (target_position - global_position) * (delta * position_smoothing_speed);
