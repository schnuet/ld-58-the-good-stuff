extends Control

func show_sweet(type: String):
	if type == "chocolate":
		$Chocolate.show();
	elif type == "lolly":
		$Lolly.show();
	elif type == "cookies":
		$Cookies.show();

func hide_sweet(type: String):
	if type == "chocolate":
		$Chocolate.hide();
	elif type == "lolly":
		$Lolly.hide();
	elif type == "cookies":
		$Cookies.hide();
