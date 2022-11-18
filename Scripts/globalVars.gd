extends Node

# Progress vars
onready var maxVal = 7
onready var currentVal = 0
onready var growFactor = 1.025
const NUMPHASES: int = 5
var currentPhase : int = 0
var currentLvl : int = 1
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
onready var moneyEarned = 10
onready var totalMoney = 0 
onready var mejoraMamalona = 0
var refreshMoneyGUI : FuncRef # Function reference used to refresh money on the GUI of the Main Scene

# Enemies Vars
var enemiesMsgs
var ENEMIES_MSGS_PATH = "res://effects/enemies_msgs.json"


func increaseMaxVal():
	self.maxVal = int(self.maxVal*self.growFactor)
	self.growFactor *= 1.025
	self.currentVal = 0.0
	self.currentPhase = (self.currentPhase+1)%self.getTotalPhases()
	Items_Tiendita["Phase"] = self.currentPhase
	
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
	load_enemies_msgs()

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
	self.currentPhase = Items_Tiendita["Phase"]
	self.currentLvl = Items_Tiendita["Level"]

func set_Tiendita(value):
	Items_Tiendita = value
	
func load_enemies_msgs():
	var file = File.new()
	file.open(ENEMIES_MSGS_PATH, File.READ)
	var content = file.get_as_text()
	file.close()
	self.enemiesMsgs = JSON.parse(content).result["Msgs"]
	print(self.enemiesMsgs)
	
func earnMoney():
	GlobalVars.totalMoney += self.moneyEarned
	Items_Tiendita["Currency"] = GlobalVars.totalMoney
	save_tienda_actual()

func lvlUp():
	self.currentLvl += 1
	Items_Tiendita["Level"] = self.currentLvl
	updateEarnRate()

func updateEarnRate():
	self.moneyEarned += floor(0.5*pow(self.currentLvl, 2))
	
func save_tienda_actual():
	var file = File.new()
	file.open(GlobalVars.TIENDA_PATH, File.WRITE)
	file.store_string(JSON.print(Items_Tiendita, " ", true))
	file.close()

