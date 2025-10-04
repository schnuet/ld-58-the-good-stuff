class_name Game
extends "../Scene.gd";

const primary_color = "#FF7532";

func _ready():
	Globals.set("game_over_reason", "none");
	
	var stopwatch = StopWatch.new();
	Globals.set("stopwatch", stopwatch);
	stopwatch.start();
	
	Globals.set("game_ready", true);

	MusicPlayer.play_music("maintheme");
	
	return true;
