extends Node2D

onready var back = $Back
onready var button = $TextureButton
onready var tween = $Tween
onready var label = $Label
const TOLERANCE = 6 # Hit tolerance factor
var makeProgressRef : FuncRef
var restorePosRef : FuncRef
var okMsgRef : FuncRef
var comboMsgRef : FuncRef
var gridPos : Vector2
var labelNum : String
var elapsedTime = 0
var initial_scale : float

# Called when the node enters the scene tree for the first time.
func _ready():
	var color1 = Color("#159fa7")
	var color2 = Color("#ab29c1")
	var color3 = Color("#a71515")
	
	back.scale *= self.initial_scale
	self.label.text = self.labelNum
	
	tween.interpolate_property(back, "modulate", color1, color2, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(back, "modulate", color2, color3, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.5)
	tween.interpolate_property(back, "scale", back.scale, 0.5*back.scale, GlobalVars.DRUM_HIT_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	button.connect("pressed", self, "isPressed")
	

func setParams(makeProgress, okMsg, comboMsg, restorePos, num, gridPosition, lifeTime):
	self.makeProgressRef = makeProgress
	self.okMsgRef = okMsg
	self.comboMsgRef = comboMsg
	self.labelNum = str(num)
	self.restorePosRef = restorePos
	self.gridPos = gridPosition
	self.elapsedTime = lifeTime
	self.initial_scale = 1 - (lifeTime/GlobalVars.DRUM_HIT_TIME)*0.5

func _process(delta):
	self.elapsedTime += delta
	if elapsedTime - GlobalVars.DRUM_HIT_TIME > GlobalVars.GOOD_HIT * self.TOLERANCE:
		GlobalVars.comboCount = 0
		self.removeMark()

func isPressed():
	if GlobalVars.DRUM_HIT_TIME - elapsedTime < GlobalVars.GOOD_HIT * self.TOLERANCE:
		self.makeProgressRef.call_func(Instruments.instruments_click_progress[Instruments.DRUM])
		self.okMsgRef.call_func()
		GlobalVars.comboCount += 1
		self.comboMsgRef.call_func()
		self.removeMark()
		
func removeMark():
	self.restorePosRef.call_func(self.gridPos)
	self.queue_free()
