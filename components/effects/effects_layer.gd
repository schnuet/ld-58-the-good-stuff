extends Node2D

func play_effect(effect_name: String, pos: Vector2):
	if effect_name == "collect_bad_sweets":
		print("play", effect_name);
		global_position = pos;
		$CollectBadSweets.visible = true;
		$CollectBadSweets.play();
		await $CollectBadSweets.animation_finished;
		$CollectBadSweets.visible = false;
		return true;
	if effect_name == "collect_chocolate":
		$CollectChocolate.visible = true;
		print("play", effect_name);
		global_position = pos;
		$CollectChocolate.play();
		await $CollectChocolate.animation_finished;
		$CollectChocolate.visible = false;
		return true;
	if effect_name == "collect_lolly":
		$CollectLolly.visible = true;
		print("play", effect_name);
		global_position = pos;
		$CollectLolly.play();
		await $CollectLolly.animation_finished;
		$CollectLolly.visible = false;
		return true;
	if effect_name == "collect_cookie":
		$CollectCookie.visible = true;
		print("play", effect_name);
		global_position = pos;
		$CollectCookie.play();
		await $CollectCookie.animation_finished;
		$CollectCookie.visible = false;
		return true;
