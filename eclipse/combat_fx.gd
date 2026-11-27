extends Node2D

var direction := Vector2.RIGHT
var skill := 1
var age := 0.0

func _process(delta: float) -> void:
	age += delta
	if age >= 0.45:
		queue_free()
	else:
		queue_redraw()

func _draw() -> void:
	var alpha := maxf(0.0, 1.0 - age / 0.45)
	var angle := direction.angle()
	var tint := Color(1.0, 0.73, 0.32, alpha)
	if skill == 1:
		for i in range(3):
			draw_arc(Vector2(0,-12), 45.0 + float(i) * 12.0 + age * 100.0, angle - 0.9, angle + 0.9, 28, Color(tint, alpha * (1.0-float(i)*0.18)), 5.0-float(i), true)
	elif skill == 2:
		var start := Vector2(0,-24)
		var tip := start + direction * minf(220.0, age*850.0)
		draw_line(start, tip, Color(0.35,0.8,1,alpha*0.28), 18, true)
		draw_line(start, tip, Color(0.68,0.96,1,alpha), 5, true)
		draw_circle(tip, 8.0, Color(0.85,1,1,alpha))
	else:
		for i in range(3):
			draw_arc(Vector2.ZERO, 45.0 + age * 170.0 + float(i)*16.0, angle + age*8.0, angle + age*8.0 + TAU - 0.25, 70, Color(0.78,0.48,1,alpha*(1.0-float(i)*0.25)), 4, true)
