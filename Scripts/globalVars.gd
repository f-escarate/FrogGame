extends Node

onready var maxVal = 7
onready var currentVal = 0
onready var growFactor = 1.2

onready var earnMultiplier = 1
onready var moneyPerClick = 1
onready var totalMoney = 0

const NUMPHASES: int = 3
var currentPhase : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func increaseMaxVal():
	self.maxVal = int(self.maxVal*self.growFactor)
	self.growFactor *= 1.2
	self.currentVal = 0.0
	
	self.currentPhase = (self.currentPhase+1)%NUMPHASES
	
	return !bool(self.currentPhase)
