extends Node2D

onready var label = $Label
var time
var defeat_fun_ref : FuncRef

# Called when the node enters the scene tree for the first time.
func _ready():
	self.time = GlobalVars.ENEMY_TIME

func setDefeatFun(fun_ref: FuncRef):
	self.defeat_fun_ref = fun_ref

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not GlobalVars.isFighting:
		self.queue_free()
	self.time -= delta
	if self.time <= 0:
		self.defeat_fun_ref.call_func()
		self.queue_free()
	label.text = str(stepify(self.time, 0.1))
