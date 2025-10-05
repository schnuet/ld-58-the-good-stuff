class_name Game
extends "../Scene.gd";

const primary_color = "#FF7532";

func sort_houses(a, b) -> bool:
	var distance_a = (a.global_position - Vector2(640, 360)).length();
	var distance_b = (b.global_position - Vector2(640, 360)).length();
	if distance_a > distance_b:
		return true;
	return false;

func _ready():
	Globals.set("game_over_reason", "none");
	
	var stopwatch = StopWatch.new();
	Globals.set("stopwatch", stopwatch);
	stopwatch.start();
	
	Globals.set("game_ready", true);

	MusicPlayer.play_music("maintheme");
	
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
