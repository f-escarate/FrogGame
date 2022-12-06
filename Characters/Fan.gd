extends Control

onready var sprite = $Sprite
onready var fan = $Sprite/AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	if randi()%2:
		sprite.texture = load("res://images/fan2.png")
	
	var grey = randf()*0.5
	sprite.modulate=Color(grey,grey,grey)
	fan.play("cheering")
	# Resizing sprite
	if rect_min_size.x < rect_min_size.y:
		var factor = rect_min_size.x/(sprite.texture.get_width()/4)
		sprite.scale = Vector2(factor,factor)
		rect_min_size.y = sprite.texture.get_height()*factor
	else:
		var factor = rect_min_size.y/sprite.texture.get_height()
		sprite.scale = Vector2(factor,factor)
		rect_min_size.x = (sprite.texture.get_width()/4)*factor
	
	# Setting sprite position
	sprite.position = rect_size/2

