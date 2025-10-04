extends "../Scene.gd";


func _on_BackButton_pressed():
	SceneManager.change_scene_to_file("res://scenes/01_start/SceneStart.tscn");


func _on_CreditsScene_hidden():
	$CanvasLayer.hide();


func _on_CreditsScene_shown():
	$CanvasLayer.show();
