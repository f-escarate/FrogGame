extends Node

# Progress vars
onready var progressValue = 0
onready var progressLimit = 7
const NUMPHASES: int = 10
var currentPhase : int = 0
var currentLvl : int = 1
onready var isFighting : bool = false

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

func increaseProgressValue(multiplier):
	self.progressValue += 1*multiplier
	Data["ProgressValue"] = self.progressValue

func increaseProgressLimit():
	self.progressLimit += floor((self.currentPhase+1)/self.NUMPHASES)
	self.progressValue = 0.0
	self.currentPhase = (self.currentPhase+1)%self.getTotalPhases()
	Data["Phase"] = self.currentPhase
	Data["ProgressLimit"] = self.progressLimit
	# the player goes to fight when the phase count is restarted
	self.isFighting = !bool(self.currentPhase) and not self.isFighting

func getTotalPhases():
	if self.isFighting:
		return 1
	return self.NUMPHASES

# Data
var Data = {} setget set_Data
const DEFAULT_DATA_PATH = "res://CompraVenta/Data.json"
const DATA_PATH = "user://Data.json" 			# Path for Android saves

func _ready():
	load_data()
	load_enemies_msgs()

func load_data():
	var file = File.new()
	if file.file_exists(DATA_PATH):
		file.open(DATA_PATH, File.READ)
	else:
		file.open(DEFAULT_DATA_PATH, File.READ) # just initialize with the base store
	var content = file.get_as_text()
	file.close()
	self.Data = JSON.parse(content).result
	self.totalMoney = Data["Currency"]
	self.currentPhase = Data["Phase"]
	self.currentLvl = Data["Level"]
	self.progressValue = Data["ProgressValue"]
	self.progressLimit = Data["ProgressLimit"]

func set_Data(value):
	Data = value
	
func load_enemies_msgs():
	var file = File.new()
	file.open(ENEMIES_MSGS_PATH, File.READ)
	var content = file.get_as_text()
	file.close()
	self.enemiesMsgs = JSON.parse(content).result["Msgs"]

func earnMoney():
	GlobalVars.totalMoney += self.moneyEarned
	Data["Currency"] = GlobalVars.totalMoney

func lvlUp():
	self.currentLvl += 1
	Data["Level"] = self.currentLvl
	updateEarnRate()

func updateEarnRate():
	self.moneyEarned += floor(0.5*pow(self.currentLvl, 2))
	
func save_data():
	var file = File.new()
	file.open(GlobalVars.DATA_PATH, File.WRITE)
	file.store_string(JSON.print(Data, " ", true))
	file.close()

