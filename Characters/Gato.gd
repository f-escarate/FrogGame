extends Node2D

onready var type = "Witch"
const INSTRUMENT = Instruments.MIC

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func remove():
	self.queue_free()
