extends Node


onready var maxVal = 10
onready var currentVal = 0
onready var growFactor = 1.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func increaseMaxVal():
	self.maxVal = int(self.maxVal*self.growFactor)
	self.growFactor *= 1.2
	self.currentVal = 0.0

