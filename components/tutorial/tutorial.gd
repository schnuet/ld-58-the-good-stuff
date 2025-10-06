extends Node2D

var slide = 0;

@onready var slide_1 = $"01Tutorial";
@onready var slide_2 = $"02Tutorial";
@onready var slide_3 = $"03Tutorial";
@onready var slide_4 = $"04Tutorial";

signal done;

var open = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not open:
		return;
	
	if Input.is_action_just_pressed("action"):
		next_slide();

func next_slide():
	if slide_1.visible:
		slide_1.hide();
		slide_2.show();
	elif slide_2.visible:
		slide_2.hide();
		slide_3.show();
	elif slide_3.visible:
		slide_3.hide();
		slide_4.show();
	elif slide_4.visible:
		slide_4.hide();
		hide();
		emit_signal("done");
