extends Node2D

onready var back = $Back
onready var button = $TextureButton
onready var tween = $Tween
onready var elapsedTime = 0
onready var hitTime = 1.0
const TOLERANCE = 2 # Hit tolerance factor
var makeProgressRef
var okMsgRef

# Called when the node enters the scene tree for the first time.
func _ready():
	var color1 = Color(1, 1, 0.7)
	var color2 = Color(1, 0.7, 0.7)
	
	tween.interpolate_property(back, "modulate", color1, color2, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(back, "scale", back.scale, Vector2(0.5, 0.5), hitTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	button.connect("pressed", self, "isPressed")

func setParams(makeProgress, okMsg):
	self.makeProgressRef = makeProgress
	self.okMsgRef = okMsg

func _process(delta):
	self.elapsedTime += delta
	if elapsedTime - self.hitTime > GlobalVars.GOOD_HIT * self.TOLERANCE:
		queue_free()

func isPressed():
	if self.hitTime - elapsedTime < GlobalVars.GOOD_HIT * self.TOLERANCE:
		self.makeProgressRef.call_func(GlobalVars.DRUM_CLICKER_PROGRESS)
		self.okMsgRef.call_func()
		return
		
