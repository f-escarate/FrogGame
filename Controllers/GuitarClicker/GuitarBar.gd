extends ColorRect

onready var Mark = preload("res://Controllers/GuitarClicker/GuitarMark.tscn")
onready var markContainer = $MarkContainer
onready var button = $Button
onready var length = abs(margin_top)

var main

# Called when the node enters the scene tree for the first time.
func _ready():
	button.connect("pressed", self, "isPressed")

func guitarMark(speed : float, noteIndex : int, initPos = 0):
	# adding Mark
	var mark = Mark.instance()
	self.markContainer.add_child(mark)
	mark.set_params(speed, self.length, noteIndex, initPos)	

func isPressed():
	var firstMark = markContainer.get_child(0)
	if firstMark != null and abs(firstMark.rect_position.y-self.length) < GlobalVars.GOOD_HIT*firstMark.speed:
		firstMark.queue_free()
		self.main.makeProgress(Instruments.instruments_click_progress[Instruments.GUITAR])
		self.main.okMsg()
		return
