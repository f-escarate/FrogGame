extends Node

# Progress vars
onready var maxVal = 7
onready var currentVal = 0
onready var growFactor = 1.025
const NUMPHASES: int = 5
var currentPhase : int = 0
onready var isFighting:bool = false

# Clicker Progress Bars
const NORMAL_CLICKER_PROGRESS = 2
const GUITAR_CLICKER_PROGRESS = 3
const DRUM_CLICKER_PROGRESS = 4

# Hit consts
const GOOD_HIT = 0.09
const PERFECT_HIT = 0.05

# GUI vars
onready var safe_area = OS.get_window_safe_area()
onready var screen_size = safe_area.end - safe_area.position
onready var width = ProjectSettings.get_setting("display/window/size/width")
onready var height = ProjectSettings.get_setting("display/window/size/height")

# Money vars
onready var earnMultiplier = 1
onready var moneyPerClick = 1
onready var totalMoney = 0 
onready var mejoraMamalona = 0

func increaseMaxVal():
	self.maxVal = int(self.maxVal*self.growFactor)
	self.growFactor *= 1.025
	self.currentVal = 0.0
	self.currentPhase = (self.currentPhase+1)%self.getTotalPhases()
	
	# the player goes to fight when the phase count is restarted
	self.isFighting = !bool(self.currentPhase) and not self.isFighting

func getTotalPhases():
	if self.isFighting:
		return 1
	return self.NUMPHASES

# Tienda
var Items_Tiendita = {} setget set_Tiendita
const STORE_PATH = "res://CompraVenta/Tienda.json"
const TIENDA_PATH = "user://Tienda.json" 			# Path for Android saves

func _ready():
	load_tiendita()

func load_tiendita():
	var file = File.new()
	if file.file_exists(TIENDA_PATH):
		file.open(TIENDA_PATH, File.READ)
	else:
		file.open(STORE_PATH, File.READ) # just initialize with the base store
	var content = file.get_as_text()
	file.close()
	self.Items_Tiendita = JSON.parse(content).result
	self.totalMoney = Items_Tiendita["Currency"]

func set_Tiendita(value):
	Items_Tiendita = value

