extends Node
class_name Clicker

# Receives an InputEventScreenTouch and does an action
func action(event: InputEventScreenTouch):
	var x = event.position.x
	var y = event.position.y
	print(x, " ", y)
