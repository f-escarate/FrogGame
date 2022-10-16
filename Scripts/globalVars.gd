extends Node

# Progress vars
onready var maxVal = 7
onready var currentVal = 0
onready var growFactor = 1.2
const NUMPHASES: int = 3
var currentPhase : int = 0

# Clicker Progress Bars
const NORMAL_CLICKER_PROGRESS = 2
const GUITAR_CLICKER_PROGRESS = 3

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


# Tienda
var Items_Tiendita = {} setget set_Tiendita

func _ready():
	load_tiendita()

func load_tiendita():
	var file = File.new()
	file.open("res://CompraVenta/Tienda.json",File.READ)
	var content = file.get_as_text()
	file.close()
	self.Items_Tiendita = JSON.parse(content).result

func set_Tiendita(value):
	Items_Tiendita = value
