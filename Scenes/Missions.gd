extends Node2D

onready var mission = preload("./Mission.tscn")
onready var background = $Background
onready var missions = $Background/ScrollContainer/MissionsContainer
onready var showMissionButton = $ShowMissionButton
onready var exit = $Background/Button
onready var funNames : Array = []
onready var args : Array = []
onready var missionsIndexes : Array = []
onready var MISSION_QUANTITY = 3

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

	for i in range(MISSION_QUANTITY):
		addRandomMission()

func addMission(json_mission, index):
	var removeMissionRef = funcref(self, "removeMission")
	var ui_mission = mission.instance()
	self.missions.add_child(ui_mission)
	
	if json_mission["args"] != null:
		json_mission["Text"] = json_mission["Text"] % json_mission["args"]
	
	ui_mission.setFields(json_mission["Text"], json_mission["reward"], removeMissionRef, index)
	self.funNames.append(json_mission["fun"])
	self.args.append(json_mission["args"])
	self.missionsIndexes.append(index)
	
func checkMissions():
	for i in range(len(funNames)):
		checkMission(i)

func checkMission(i):
	var fun_ref = funcref(self, funNames[i])
	var missionComplete : bool = fun_ref.call_func(args[i])
	if missionComplete:
		var ui_mission = self.missions.get_child(i)
		ui_mission.setCompleted()

func removeMission(index):
	var i = self.missionsIndexes.find(index, 0)
	# Updating mission values
	updateMissionValues(i)
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

func addRandomMission():
	var file = File.new()
	file.open("res://JSONs/missions.json", File.READ)
	var content = file.get_as_text()
	file.close()
	var json_missions = JSON.parse(content).result
	
	var index : int = randi()%len(json_missions)	# Selecting a random mission
	while true:			
		# Checking that isn't repeated and is a renewable mission
		if !(index in self.missionsIndexes) and json_missions[index]["renewable"]:
			addMission(json_missions[index], index)
			break
		index = randi()%len(json_missions)
	
	# checking new mission
	checkMission(len(missionsIndexes)-1)

func increaseIntArg(missionIndex, multiplier = 2):
	var file = File.new()
	file.open("res://JSONs/missions.json", File.READ)
	var content = file.get_as_text()
	file.close()
	var json_missions = JSON.parse(content).result
	json_missions[missionIndex]["args"] *= multiplier
	file = File.new()
	file.open("res://JSONs/missions.json", File.WRITE)
	file.store_string(JSON.print(json_missions, " ", true))
	file.close()

func noRenewable(missionIndex):
	var file = File.new()
	file.open("res://JSONs/missions.json", File.READ)
	var content = file.get_as_text()
	file.close()
	var json_missions = JSON.parse(content).result
	json_missions[missionIndex]["renewable"] = false
	file = File.new()
	file.open("res://JSONs/missions.json", File.WRITE)
	file.store_string(JSON.print(json_missions, " ", true))
	file.close()

# Updates the mission values if is a mission that depends on a number
#  and if is a mission that has to be called once, then make it no renewable
func updateMissionValues(i):
	var arg = self.args[i]
	if arg == null:
		noRenewable(self.missionsIndexes[i])
	elif typeof(arg) == TYPE_REAL:
		increaseIntArg(self.missionsIndexes[i])
	
# ----------------- Missions functions -----------------------------

func allBossesBeaten(_noArgs):
	return len(GlobalVars.defeatedBosses) == len(GlobalVars.enemiesNames)

func hasAllInstruments(_noArgs):
	var i = 0
	var numInstruments = len(Instruments.instruments_unlocked)
	while i < numInstruments and Instruments.instruments_unlocked[i]:
		i += 1
	return i == numInstruments
	
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


