extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var words = $Label 	
onready var tween = $Tween
onready var sprite = $Sprite
onready var sfx_player = $AudioStreamPlayer
onready var enemiesExplosionColors = [Color("#d28c0dcc"), Color("#d2e59906")]
onready var enemiesTextColors = [Color("#b789e9"), Color("#e0bc41")]
var enemyType : int

# Called when the node enters the scene tree for the first time.
func _ready():
	# explosion sound
	self.sfx_player.stream = load("res://Assets/SFX/explosion.mp3")
	self.sfx_player.play()
	
	
	# Setting pause mode
	self.pause_mode = Node.PAUSE_MODE_PROCESS 
	#get_tree().paused = true
	
	# Setting the enemy message to the label
	words.text = GlobalVars.enemiesMsgs[self.enemyType]
	
	self.sprite.modulate = self.enemiesExplosionColors[self.enemyType]
	
	var color1 = self.enemiesTextColors[self.enemyType]
	var color2 = color1
	color2.a = 0
	tween.interpolate_property(words, "modulate", color2, color1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(words, "modulate", color1, color2, 2, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(sprite, "scale", Vector2(1,1), Vector2(3.5,3.5), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(sprite, "scale", Vector2(3.5,3.5), Vector2(1,1), 2, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)	
	tween.start()

func setEnemyType(enemyType : int):
	self.enemyType = enemyType

# That function is called by the animation player (when the explosion ends)
func _remove():
	queue_free()

# That function is called by the animation player (when the letters ends)
func resume():
	get_tree().paused = false
	
