extends Node

# This is a global script to manage any instances that should be reachable
# everywhere from a central location.

var sweets = [];
var max_sweets = 3;
var collected_houses = [];
var collected_houses_in_run = [];

var secured_main_sweets = {
	"chocolate": false,
	"cookies": false,
	"lolly": false
};
var collected_main_sweets = [];

func add_sweet(sweet):
	sweets.append(sweet);
	
	if sweets.size() > max_sweets:
		var oldest_sweet = sweets.pop_front();
		oldest_sweet.queue_free();

func lose_all_sweets():
	for sweet in sweets:
		sweet.queue_free();
	sweets.clear();

	for key in secured_main_sweets.keys():
		secured_main_sweets[key] = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
