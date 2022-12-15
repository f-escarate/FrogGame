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
	self.progressValue += floor((1+ self.mejoraMamalona/4)*multiplier)
	Data["ProgressValue"] = self.progressValue

func refreshProgress():
	self.currentPhase = (self.currentPhase+1)%(self.getTotalPhases()+1)
	self.progressLimit = self.currentLvl*5 + self.currentPhase*2
	
	
func _increaseProgressLimit():
	# the player goes to fight when the phase count is restarted
	self.isFighting = self.currentPhase == self.NUMPHASES and !self.isFighting
	
	if isFighting:
		self.progressValue = 0
		self.progressLimit = (self.currentLvl*3 + self.NUMPHASES)*3
		return
		
	if self.progressValue >= self.progressLimit:
		self.progressValue = self.progressValue-self.progressLimit
		refreshProgress()
		increaseProgressLimit()


func increaseProgressLimit():
	_increaseProgressLimit()
	
	Data["Phase"] = self.currentPhase
	Data["ProgressValue"] = self.progressValue
	Data["ProgressLimit"] = self.progressLimit

func getTotalPhases():
	if self.isFighting:
		return 1
	return self.NUMPHASES

# Data
var Data = {} setget set_Data
const DEFAULT_DATA_PATH = "res://JSONs/Data.json"
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
	self.fansNumber = Data["Fans"]
	self.defeatedBoss = Data["LastDefeatedBoss"]
	self.mejoraMamalona = Data["Inventory"]["Lessons"]["buff_real"]

func set_Data(value):
	Data = value
	
func save_data():
	self.Data["Currency"] = self.totalMoney
	self.Data["LastDefeatedBoss"] = self.defeatedBoss
	GlobalVars.Data["Inventory"]["Lessons"]["buff_real"] = self.mejoraMamalona

	var file = File.new()
	file.open(GlobalVars.DATA_PATH, File.WRITE)
	file.store_string(JSON.print(Data, " ", true))
	file.close()

# Money vars
onready var moneyEarned :int = 10
onready var totalMoney : int = 0 
onready var item_upgrades = Item_Upgrades.new()
var refreshMoneyGUI : FuncRef # Function reference used to refresh money on the GUI of the Main Scene

func earnMoney():
	GlobalVars.totalMoney += self.moneyEarned*(1+self.fansNumber*0.1 + GlobalVars.mejoraMamalona/2)
	Data["Currency"] = GlobalVars.totalMoney

func lvlUp():
	self.currentLvl += 1
	Data["Level"] = self.currentLvl
	updateEarnRate()

func updateEarnRate():
	self.moneyEarned += floor(0.25*pow(self.currentLvl, 2))

# Enemies Vars
var enemiesMsgs : Array
var enemiesNames : Array
const ENEMIES_MSGS_PATH = "res://JSONs/enemies_msgs.json"
const ENEMY_TIME = 20

func load_enemies_msgs():
	var file = File.new()
	file.open(ENEMIES_MSGS_PATH, File.READ)
	var content = file.get_as_text()
	file.close()
	var json_res = JSON.parse(content).result
	self.enemiesMsgs = json_res["Msgs"]
	self.enemiesNames = json_res["Enemies"]

# Fans vars
var fansNumber : int
var fanGUIRefresh_fun_ref : FuncRef

func addFans(n):
	self.fansNumber = max(0, self.fansNumber+n)
	self.Data["Fans"] = self.fansNumber
	fanGUIRefresh_fun_ref.call_func()
	self.save_data()
	
# Missions vars
var defeatedBoss : String
var refreshMissionsRef : FuncRef

# Lessons vars
onready var mejoraMamalona = 0 setget set_mamalon

func set_mamalon(value):
	mejoraMamalona = value

