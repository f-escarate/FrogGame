extends Node2D

onready var bar0 = $Bar
onready var bar1 = $Bar2
onready var bar2 = $Bar3
onready var bar3 = $Bar4
onready var bars : Array = [bar0, bar1, bar2, bar3]

var depth : int
var main

# Called when the node enters the scene tree for the first time.
func _ready():
	self.depth = bar0.length
	for bar in self.bars:
		bar.main = self.main

func setParams(aMain):
	self.main = aMain
	

func addMark(speed: float, noteIndex: int):
	var randIndex : int = randi()%4
	bars[randIndex].guitarMark(speed, noteIndex)

