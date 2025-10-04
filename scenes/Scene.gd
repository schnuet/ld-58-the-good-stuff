class_name Scene
extends Node

signal shown
signal hidden

func _ready():
	var _s_hidden = self.connect("hidden", Callable(self, "on_hide"));
	var _s_shown = self.connect("shown", Callable(self, "on_show"));

func on_show():
	pass

func on_hide():
	pass
