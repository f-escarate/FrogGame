extends ColorRect

onready var Mark = preload("res://Controllers/GuitarClicker/GuitarMark.tscn")
onready var markContainer = $MarkContainer
onready var button = $Button

var guitarClicker
var main

# Called when the node enters the scene tree for the first time.
func _ready():
	button.connect("pressed", self, "isPressed")

func guitarMark(speed : float, noteIndex : int):
	# Mark
	var mark = Mark.instance()
	self.markContainer.add_child(mark)
	mark.set_params(speed)	

func isPressed():	
	if self.guitarClicker.rhythm[self.guitarClicker.index] - self.guitarClicker.noteTime < GlobalVars.GOOD_HIT:
		self.guitarClicker.advanceNote()
		self.main.makeProgress()
		return true
	return false
