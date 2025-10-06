extends "../Scene.gd";


func _ready():
	$Node2D/PlayerAnimation.play();
	$AnimationPlayer.play("walk");
	$Node2D/PaulaPumpkin00000.play();
	return;

func _process(_delta: float) -> void:
	if not $Node2D/PlayerAnimation/AudioStreamPlayer2D.playing:
		$Node2D/PlayerAnimation/AudioStreamPlayer2D.play();

func _unhandled_input(event):
	if event.is_action("action"):
		_on_start_button_pressed();

func _on_CreditsButton_pressed():
	change_to_scene("SceneCredits");


func change_to_scene(new_scene_id: String):
	var fade_out_options = SceneManager.create_options(1.0, "fade", 0.1, false);
	var fade_in_options = SceneManager.create_options(1.0, "fade", 0.1, false);
	var general_options = SceneManager.create_general_options(Color.BLACK, 3.0, false, true);
	SceneManager.change_scene(new_scene_id, fade_out_options, fade_in_options, general_options);


func _on_start_button_pressed() -> void:
	Globals.set("game_ready", false);
	$CanvasLayer/StartButton.hide();
	await get_tree().create_timer(0.2).timeout;
	change_to_scene("SceneGame");
