extends ColorRect

onready var Mark = preload("res://Controllers/GuitarClicker/GuitarMark.tscn")
onready var markContainer = $MarkContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	guitarMark(50)
	pass

func guitarMark(speed : float):
	# Mark
	var mark = Mark.instance()
	self.markContainer.add_child(mark)
	mark.set_params(speed)	
