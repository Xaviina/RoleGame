extends Control

var time := 0.0

func _process(delta):
	time += delta
	
	var pulse = 1.0 + sin(time * 1.2) * 0.015
	scale = Vector2(pulse, pulse)
