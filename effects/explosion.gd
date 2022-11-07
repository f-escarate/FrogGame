extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var words = $Label 	
onready var tween = $Tween
onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS 
	get_tree().paused = true
	var color1 = words.modulate
	var color2 = words.modulate
	color2.a = 0
	tween.interpolate_property(words, "modulate", color2, color1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(words, "modulate", color1, color2, 2, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(sprite, "scale", Vector2(3,3), Vector2(8,8), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(sprite, "scale", Vector2(8,8), Vector2(3,3), 2, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)	
	tween.start()

# That function is called by the animation player (when the explosion ends)
func _remove():
	queue_free()

# That function is called by the animation player (when the letters ends)
func resume():
	get_tree().paused = false
	
