extends ColorRect

@onready var offset_node = $SubViewport/OffsetNode;
@onready var camera: Camera2D = get_tree().get_first_node_in_group("camera");

@onready var player: Node2D = get_tree().get_first_node_in_group("player");
@onready var player_shine = $SubViewport/OffsetNode/PlayerShine;

func _ready() -> void:
	player_shine.play();

func _process(delta: float) -> void:
	offset_node.global_position = -camera.global_position;
	
	player_shine.global_position = player.global_position;
