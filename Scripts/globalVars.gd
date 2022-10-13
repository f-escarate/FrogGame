extends Node

# Progress vars
onready var maxVal = 7
onready var currentVal = 0
onready var growFactor = 1.2
const NUMPHASES: int = 1
var currentPhase : int = 0

# Hit consts
const GOOD_HIT = 0.09
const PERFECT_HIT = 0.05

# Money vars
onready var earnMultiplier = 1
onready var moneyPerClick = 1
onready var totalMoney = 0

# GUI vars
onready var safe_area = OS.get_window_safe_area()
onready var screen_size = safe_area.end - safe_area.position
onready var width = ProjectSettings.get_setting("display/window/size/width")
onready var height = ProjectSettings.get_setting("display/window/size/height")

func increaseMaxVal():
	self.maxVal = int(self.maxVal*self.growFactor)
	self.growFactor *= 1.2
	self.currentVal = 0.0
	
	self.currentPhase = (self.currentPhase+1)%NUMPHASES
	
	return !bool(self.currentPhase)
