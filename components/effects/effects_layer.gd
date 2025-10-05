extends Node2D

func play_effect(effect_name: String, pos: Vector2):
	if effect_name == "collect_bad_sweets":
		print("play", effect_name);
		global_position = pos;
		$CollectBadSweets.play();
		return await $CollectBadSweets.animation_finished;
	if effect_name == "collect_chocolate":
		print("play", effect_name);
		global_position = pos;
		$CollectChocolate.play();
		return await $CollectChocolate.animation_finished;
