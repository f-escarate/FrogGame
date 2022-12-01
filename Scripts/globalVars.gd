extends Node

# GUI vars
onready var safe_area = OS.get_window_safe_area()
onready var screen_size = safe_area.end - safe_area.position
onready var width = ProjectSettings.get_setting("display/window/size/width")
onready var height = ProjectSettings.get_setting("display/window/size/height")

# Hit consts
const GOOD_HIT = 0.09
const PERFECT_HIT = 0.05
const DRUM_HIT_TIME = 1.0

# Progress vars
var progressValue
var progressLimit
const NUMPHASES: int = 10
var currentPhase : int = 0
var currentLvl : int = 1
onready var isFighting : bool = false

func increaseProgressValue(multiplier):
	self.progressValue += 1*multiplier
	Data["ProgressValue"] = self.progressValue

func increaseProgressLimit():
	self.progressLimit = self.currentLvl*3 + self.currentPhase
	self.progressValue = 0.0
	self.currentPhase = (self.currentPhase+1)%self.getTotalPhases()
	Data["Phase"] = self.currentPhase
	Data["ProgressLimit"] = self.progressLimit
	# the player goes to fight when the phase count is restarted
	self.isFighting = !bool(self.currentPhase) and not self.isFighting
	if self.isFighting:
		self.progressLimit *= 3

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
	load_instruments_data()

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
	
func save_data():
	var file = File.new()
	file.open(GlobalVars.DATA_PATH, File.WRITE)
	file.store_string(JSON.print(Data, " ", true))
	file.close()

# Money vars
onready var moneyEarned = 10
onready var totalMoney = 0 
onready var mejoraMamalona = 0
onready var item_upgrades = Item_Upgrades.new()
var refreshMoneyGUI : FuncRef # Function reference used to refresh money on the GUI of the Main Scene

func earnMoney():
	GlobalVars.totalMoney += self.moneyEarned
	Data["Currency"] = GlobalVars.totalMoney

func lvlUp():
	self.currentLvl += 1
	Data["Level"] = self.currentLvl
	updateEarnRate()

func updateEarnRate():
	self.moneyEarned += floor(0.5*pow(self.currentLvl, 2))

# Enemies Vars
var enemiesMsgs
const ENEMIES_MSGS_PATH = "res://effects/enemies_msgs.json"

func load_enemies_msgs():
	var file = File.new()
	file.open(ENEMIES_MSGS_PATH, File.READ)
	var content = file.get_as_text()
	file.close()
	self.enemiesMsgs = JSON.parse(content).result["Msgs"]
	
# Instruments vars/consts
const DEFAULT_INSTRUMENT_INFO_PATH = "res://Scenes/instruments.json"
const INSTRUMENT_INFO_PATH = "user://instruments.json" 			# Path for Android saves
var NORMAL_CLICKER_PROGRESS = 2
var GUITAR_CLICKER_PROGRESS = 3
var DRUM_CLICKER_PROGRESS = 4

var instruments_unlocked : Array
var instruments_click_progress : Array
var refreshInstruments : FuncRef # Function reference used to refresh the unlocked instruments


func read_instrument_file():
	var file = File.new()
	if file.file_exists(INSTRUMENT_INFO_PATH):
		file.open(INSTRUMENT_INFO_PATH, File.READ)
	else:
		file.open(DEFAULT_INSTRUMENT_INFO_PATH, File.READ)
	var content = file.get_as_text()
	file.close()
	var data = JSON.parse(content).result
	return data

func write_instrument_data(content):
	var file = File.new()
	file.open(GlobalVars.INSTRUMENT_INFO_PATH, File.WRITE)
	file.store_string(JSON.print(content, " ", true))
	file.close()

func load_instruments_data():
	var data = read_instrument_file()
	self.instruments_unlocked = data["unlocked"]
	self.instruments_click_progress = data["click_progress"]
	
	NORMAL_CLICKER_PROGRESS = data["click_progress"][0]
	GUITAR_CLICKER_PROGRESS = data["click_progress"][1]
	DRUM_CLICKER_PROGRESS = data["click_progress"][2]

func unlock_instrument(index : int):
	# Reading
	var content = read_instrument_file()
	# Unlocking instrument
	content["unlocked"][index] = true
	self.instruments_unlocked = content["unlocked"]
	# Writing
	write_instrument_data(content)
	# Refreshing GUI
	self.refreshInstruments.call_func()

func upgrade_instrument(index : int, factor : int):
	# Reading
	var content = read_instrument_file()
	# Upgrading instrument
	content["click_progress"][index] = factor
	# Writing
	write_instrument_data(content)
	# Reloading data
	NORMAL_CLICKER_PROGRESS = content["click_progress"][0]
	GUITAR_CLICKER_PROGRESS = content["click_progress"][1]
	DRUM_CLICKER_PROGRESS = content["click_progress"][2]
	self.instruments_click_progress = content["click_progress"]
