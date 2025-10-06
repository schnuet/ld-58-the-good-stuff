extends "../Scene.gd";

func _ready():
	$PaulaPumpkin00000.play();
	$PlayerAnimation.play();
	$AnimationPlayer.play("updown");

func _on_BackButton_pressed():
	var fade_out_options = SceneManager.create_options(1.0, "fade", 0.1, false);
	var fade_in_options = SceneManager.create_options(1.0, "fade", 0.1, false);
	var general_options = SceneManager.create_general_options(Color.BLACK, 3.0, false, true);
	SceneManager.change_scene("SceneStart", fade_out_options, fade_in_options, general_options);

func _on_CreditsScene_hidden():
	$CanvasLayer.hide();


func _on_CreditsScene_shown():
	$CanvasLayer.show();
