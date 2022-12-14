extends Node2D

onready var mission = preload("./Mission.tscn")
onready var background = $Background
onready var missions = $Background/ScrollContainer/MissionsContainer
onready var showMissionButton = $ShowMissionButton
onready var exit = $Background/Button
onready var funNames : Array = []
onready var missionsIndexes : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	refreshMissions()
	exit.connect("button_down", self, "changeVisibility")
	showMissionButton.connect("released", self, "changeVisibility")
	checkMissions()
	
func changeVisibility():
	background.visible = not background.visible

func refreshMissions():
	var file = File.new()
	file.open("res://JSONs/missions.json", File.READ)
	var content = file.get_as_text()
	file.close()
	var json_missions = JSON.parse(content).result

	for i in range(len(json_missions)):
		var mission = json_missions[i]
		addMission(mission, i)

func addMission(json_mission, index):
	var removeMissionRef = funcref(self, "removeMission")
	var ui_mission = mission.instance()
	self.missions.add_child(ui_mission)
	ui_mission.setFields(json_mission["Text"], json_mission["reward"], removeMissionRef, index)
	self.funNames.append(json_mission["fun"])
	self.missionsIndexes.append(index)
	
func checkMissions():
	for i in range(len(funNames)):
		checkMission(i)

func checkMission(i):
	var fun_ref = funcref(self, funNames[i])
	var missionComplete : bool = fun_ref.call_func()
	if missionComplete:
		var ui_mission = self.missions.get_child(i)
		ui_mission.setCompleted()

func removeMission(index):
	var i = self.missionsIndexes.find(index, 0)
	# Removing info
	self.funNames.remove(i)
	self.missionsIndexes.remove(i)
	# Removing UI
	var ui_mission = self.missions.get_child(i)
	self.missions.remove_child(ui_mission)
	ui_mission.queue_free()
	# Adding another random mission
	self.addRandomMission()

func addRandomMission():
	var file = File.new()
	file.open("res://JSONs/missions.json", File.READ)
	var content = file.get_as_text()
	file.close()
	var json_missions = JSON.parse(content).result
	
	var index : int = randi()%len(json_missions)	# Selecting a random mission
	while index in self.missionsIndexes:			# Checking that isn't repeated
		index = randi()%len(json_missions)
	
	addMission(json_missions[index], index)
	
	# checking new mission
	checkMission(len(missionsIndexes)-1)

# ----------------- Missions functions -----------------------------

func allBossesBeaten():
	return len(GlobalVars.defeatedBosses) == len(GlobalVars.enemiesNames)

func hasAllInstruments():
	var i = 0
	var numInstruments = len(Instruments.instruments_unlocked)
	while i < numInstruments and Instruments.instruments_unlocked[i]:
		i += 1
	return i == numInstruments
	
func has20Fans():
	return GlobalVars.fansNumber >= 20

func guitarLvl5():
	var inventory = GlobalVars.Data["Inventory"]
	if inventory.has("Guitar"):
		return inventory["Guitar"]["lvl"] > 5
	return false


