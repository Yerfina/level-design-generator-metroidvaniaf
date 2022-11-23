extends Node2D

var liste_traits = []

func _process(delta) :
	update()

func _draw():
	for trait in liste_traits :
		draw_line(trait[0],trait[1],Color(0,0,0))
