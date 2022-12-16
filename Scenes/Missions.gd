extends Node2D

onready var mission = preload("./Mission.tscn")
onready var background = $Background
onready var missions = $Background/ScrollContainer/MissionsContainer
onready var showMissionButton = $ShowMissionButton
onready var exit = $Background/Button
onready var funNames : Array = []
onready var args : Array = []
onready var missionsIndexes : Array
const MISSIONS_PATH = "user://missions.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	if !file.file_exists(MISSIONS_PATH):
		file.open("res://JSONs/missions.json", File.READ)
		var content = file.get_as_text()
		file.close()
		var json_missions = JSON.parse(content).result
		file = File.new()
		file.open(MISSIONS_PATH, File.WRITE)
		file.store_string(JSON.print(json_missions, " ", true))
		file.close()
	
	refreshMissions()
	exit.connect("button_down", self, "changeVisibility")
	showMissionButton.connect("released", self, "changeVisibility")
	checkMissions()
	
func changeVisibility():
	background.visible = not background.visible

func refreshMissions():
	var file = File.new()
	file.open(MISSIONS_PATH, File.READ)
	var content = file.get_as_text()
	file.close()
	var json_missions = JSON.parse(content).result
	self.missionsIndexes = json_missions["currentMissionsIndexes"]
	
	for index in missionsIndexes:
		var mission = json_missions["allMissions"][index]
		addMission(mission, index)

func addMission(json_mission, index):
	var removeMissionRef = funcref(self, "removeMission")
	var ui_mission = mission.instance()
	self.missions.add_child(ui_mission)
	
	if json_mission["format"]:
		json_mission["Text"] = json_mission["Text"] % json_mission["args"]
	
	ui_mission.setFields(json_mission["Text"], json_mission["reward"], removeMissionRef, index)
	self.funNames.append(json_mission["fun"])
	self.args.append(json_mission["args"])
	
func checkMissions():
	var aux = false
	for i in range(len(funNames)):
		if checkMission(i) == true:
			aux = true
	if aux == true:
		self.showMissionButton.normal = load("res://images/onemision.png")
		self.showMissionButton.pressed = load("res://images/pressed2.png")
	else:
		self.showMissionButton.normal = load("res://images/misions.png")
		self.showMissionButton.pressed = load("res://images/pressed1.png")
	GlobalVars.defeatedBoss = ""

func checkMission(i):
	var fun_ref = funcref(self, funNames[i])
	var missionComplete : bool = fun_ref.call_func(args[i])
	if missionComplete:
		var ui_mission = self.missions.get_child(i)
		ui_mission.setCompleted()
	return missionComplete
	

func removeMission(index):
	# Updating mission values
	updateMissionValues(index)
	var i = self.missionsIndexes.find(index, 0)
	# Removing info
	self.funNames.remove(i)
	self.missionsIndexes.remove(i)
	self.args.remove(i)
	# Removing UI
	var ui_mission = self.missions.get_child(i)
	self.missions.remove_child(ui_mission)
	ui_mission.queue_free()
	# Adding another random mission
	self.addRandomMission()
	self.writeMissionCurrentIndexes()

func addRandomMission():
	var file = File.new()
	file.open(MISSIONS_PATH, File.READ)
	var content = file.get_as_text()
	file.close()
	var json_missions = JSON.parse(content).result["allMissions"]
	
	var index : int = randi()%len(json_missions)	# Selecting a random mission
	while true:			
		# Checking that isn't repeated and is a available mission
		if !(index in self.missionsIndexes) and json_missions[index]["available"]:
			addMission(json_missions[index], index)
			self.missionsIndexes.append(index)
			break
		index = randi()%len(json_missions)
	
	# checking new mission
	checkMission(len(missionsIndexes)-1)

func writeMissionCurrentIndexes():
	var file = File.new()
	file.open(MISSIONS_PATH, File.READ)
	var content = file.get_as_text()
	file.close()
	var json_missions = JSON.parse(content).result
	json_missions["currentMissionsIndexes"] = self.missionsIndexes
	file = File.new()
	file.open(MISSIONS_PATH, File.WRITE)
	file.store_string(JSON.print(json_missions, " ", true))
	file.close()


func _changeMissionArgs(missionIndex, args):
	var file = File.new()
	file.open(MISSIONS_PATH, File.READ)
	var content = file.get_as_text()
	file.close()
	var json_missions = JSON.parse(content).result
	json_missions["allMissions"][missionIndex]["args"] = args
	file = File.new()
	file.open(MISSIONS_PATH, File.WRITE)
	file.store_string(JSON.print(json_missions, " ", true))
	file.close()

# Updates the mission values if is a mission that depends on a number
#  and if is a mission that has to be called once, then make it unavailable
func updateMissionValues(index):
	var file = File.new()
	file.open(MISSIONS_PATH, File.READ)
	var content = file.get_as_text()
	file.close()
	var json_missions = JSON.parse(content).result

	var arg = json_missions["allMissions"][index]["args"]
	if json_missions["allMissions"][index].has("once"):
		# Making unavailable
		json_missions["allMissions"][index]["available"] = false
	
	if json_missions["allMissions"][index].has("unlocks"):
		# Unlocking another mission
		var missionIndex = json_missions["allMissions"][index]["unlocks"]
		json_missions["allMissions"][missionIndex]["available"] = true

	if typeof(arg) == TYPE_REAL:
		json_missions["allMissions"][index]["args"] *= 2
	
	file = File.new()
	file.open(MISSIONS_PATH, File.WRITE)
	file.store_string(JSON.print(json_missions, " ", true))
	file.close()
	
# ----------------- Missions functions -----------------------------

func bossesBeaten(args):
	var missingBosses = args[0]
	var defeatedBosses = args[1]
	var missionIndex = args[2]
	if !(GlobalVars.defeatedBoss in missingBosses):
			return false
		
	missingBosses.erase(GlobalVars.defeatedBoss)
	defeatedBosses.append(GlobalVars.defeatedBoss)
	if len(missingBosses) == 0:
		_changeMissionArgs(missionIndex, [defeatedBosses, missingBosses, missionIndex])
		return true
	_changeMissionArgs(missionIndex, [missingBosses, defeatedBosses, missionIndex])
	return false

func hasAnInstrument(instrumentIndex):
	return Instruments.instruments_unlocked[instrumentIndex]
	
func hasNFans(N):
	return GlobalVars.fansNumber >= N

func micLvl(lvl):
	var inventory = GlobalVars.Data["Inventory"]
	if inventory.has("Mic"):
		return inventory["Mic"]["lvl"] >= lvl
	return false

func guitarLvl(lvl):
	var inventory = GlobalVars.Data["Inventory"]
	if inventory.has("Guitar"):
		return inventory["Guitar"]["lvl"] >= lvl
	return false

func drumLvl(lvl):
	var inventory = GlobalVars.Data["Inventory"]
	if inventory.has("Drum"):
		return inventory["Drum"]["lvl"] >= lvl
	return false


