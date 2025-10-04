@tool
class_name Circle2D
extends Marker2D

@export var radius: float = 10.0: set = set_radius
@export var color: Color = Color.WHITE: set = set_color
@export var stroke_color := Color.TRANSPARENT: set = set_stroke_color
@export var stroke_width := 2.0: set = set_stroke_width

func set_color(value):
	color = value
	update()

func set_radius(value):
	radius = value
	update()

func set_stroke_color(value):
	stroke_color = value
	update()

func set_stroke_width(value):
	stroke_width = value
	update()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
	if stroke_color != Color.TRANSPARENT:
		draw_arc(Vector2.ZERO, radius - (stroke_width/2.0), 0.0, 2*PI, 200,
			stroke_color, stroke_width, true)
