class_name Game
extends "../Scene.gd";

const primary_color = "#FF7532";

@onready var record_player: Node2D = $Objects/RecordPlayer;
@onready var ambient: AudioStreamPlayer = $Ambient;
@onready var player = get_tree().get_first_node_in_group("player");


func _ready():
	player.paused = true;
	$CanvasModulate.visible = true;
	Globals.set("game_over_reason", "none");
	
	Globals.set("game_ready", true);
	
	var houses = get_tree().get_nodes_in_group("house");
	houses.sort_custom(sort_houses);
	print(houses);
	
	houses[12].make_special();
	houses[12].sweet_type = "lolly";
	houses[22].make_special();
	houses[22].sweet_type = "chocolate";
	houses[32].make_special();
	houses[32].sweet_type = "cookies";
	
	return true;

func _process(_delta: float) -> void:
	if not ambient.playing:
		ambient.play()
	
	# set the ambient volume based on the distance to the audio stream player
	# the farther away, the louder it gets
	if record_player == null or ambient == null:
		return;
	
	if player == null:
		return;

	
	var distance = (player.global_position - record_player.global_position).length();
	if distance < 500:
		ambient.volume_db = -80.0;
		return;
	if distance >= 500 and distance < 1000:
		var volume = clamp((distance - 500) / 500.0, 0.0, 1.0);
		ambient.volume_db = lerp(-80.0, -30.0, volume);
		return;
	else:
		var max_distance = 3000.0;
		var volume = clamp((distance - 1000.0) / max_distance, 0.0, 1.0);
		ambient.volume_db = lerp(-30.0, 0.0, volume);

func sort_houses(a, b) -> bool:
	var distance_a = (a.global_position - Vector2(640, 360)).length();
	var distance_b = (b.global_position - Vector2(640, 360)).length();
	if distance_a < distance_b:
		return true;
	return false;


func _on_tutorial_done() -> void:
	print("tuorial done");
	player.paused = false;
	$CanvasLayer/Tutorial.queue_free();
