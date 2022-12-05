extends Control

onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	# Resizing sprite
	if rect_min_size.x < rect_min_size.y:
		var factor = rect_min_size.x/sprite.texture.get_width()
		sprite.scale = Vector2(factor,factor)
		rect_min_size.y = sprite.texture.get_height()*factor
	else:
		var factor = rect_min_size.y/sprite.texture.get_height()
		sprite.scale = Vector2(factor,factor)
		rect_min_size.x = sprite.texture.get_width()*factor
	
	# Setting sprite position
	sprite.position = rect_size/2

