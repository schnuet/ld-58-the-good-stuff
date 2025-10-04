extends AnimatedSprite2D


func _on_Logo_animation_finished():
	animation = "loop";


func _on_Timer_timeout():
	play();
