extends Node2D


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("test"):
		play_effect("lamp_upgrade", Vector2.ZERO);

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
		
	if effect_name == "lamp_upgrade":
		global_position = Vector2(0, 0);
		var lamp_upgrade = $LampUpgrade;
		var color_rect = $ColorRect;
		lamp_upgrade.show();
		lamp_upgrade.modulate = Color.TRANSPARENT;
		var start_position = lamp_upgrade.position;
		lamp_upgrade.position += Vector2(0, 100);
		print("do effect lamp upgrade");
		var tween_in_pos = get_tree().create_tween();
		var tween_in_mod = get_tree().create_tween();
		var tween_in_back = get_tree().create_tween();
		tween_in_pos.set_ease(Tween.EASE_OUT);
		tween_in_mod.set_ease(Tween.EASE_OUT);
		tween_in_back.set_ease(Tween.EASE_OUT);
		tween_in_back.tween_property(color_rect, "modulate", Color(0, 0, 0, 0.4), 0.2);
		tween_in_pos.tween_property(lamp_upgrade, "position", start_position, 0.5);
		tween_in_mod.tween_property(lamp_upgrade, "modulate", Color.WHITE, 0.5);
		await tween_in_pos.finished;
		await get_tree().create_timer(1).timeout;
		var tween_out_pos = get_tree().create_tween();
		var tween_out_mod = get_tree().create_tween();
		var tween_out_back = get_tree().create_tween();
		tween_out_pos.set_ease(Tween.EASE_OUT);
		tween_out_mod.set_ease(Tween.EASE_OUT);
		tween_out_back.set_ease(Tween.EASE_OUT);
		tween_out_pos.tween_property(lamp_upgrade, "position", start_position - Vector2(0, 30), 0.5);
		tween_out_mod.tween_property(lamp_upgrade, "modulate", Color.TRANSPARENT, 0.5);
		tween_out_back.tween_property(color_rect, "modulate", Color.TRANSPARENT, 0.2);
		await tween_out_pos.finished;
		lamp_upgrade.hide();
		lamp_upgrade.position = start_position;
		return true;
