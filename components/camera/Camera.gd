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
	var future_player_position = player_position + player.velocity * 1;

	var target_position = Vector2(future_player_position.x, future_player_position.y + Y_OFFSET);
	
	var target_zoom = 0.8;

	if player_position.x > 0 and player_position.x < 1280 and player_position.y > 100 and player_position.y < 720:
		target_position.x = 640;
		target_position.y = 360;
	
	if player_position.x > -200 and player_position.x < 1480 and player_position.y > -200 and player_position.y < 920:
		target_zoom = 0.75;
	
	# smooth follow
	var delta = get_process_delta_time();
	var position_smoothing_speed = 1;
	if global_position != target_position:
		global_position += (target_position - global_position) * (delta * position_smoothing_speed);
		
	# smooth change zoom
	var zoom_smoothing_speed = 2;
	if zoom.x != target_zoom:
		zoom.x += (target_zoom - zoom.x) * (delta * zoom_smoothing_speed);
		zoom.y = zoom.x;
