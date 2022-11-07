extends Clicker
class_name DrumClicker

const HIT_TIME: float = 1.0
onready var DrumMark = preload("res://Controllers/DrumClicker/DrumMark.tscn")
var makeProgress
var okMsg

func _init(player, main).(player, main):
	self.rhythm = getRhythmListFromFile("res://Assets/Songs/KomikuBicycle.tres")
	self.musicPlayer.stream = load("res://Assets/Songs/KomikuBicycle.mp3")
	# Play the song
	self.musicPlayer.play()
	
	# Func refs
	self.makeProgress = funcref(self.main, "makeProgress")
	self.okMsg = funcref(self.main, "okMsg")
		
func _ready():
	# Get initial display time
	self.displayTime = 0

# It's called every cycle in order to refresh the rhythm
func refreshNotes(delta) -> void:
	# We get the current time	
	self.displayTime += delta
	
	# Spawn the marks that show the rhythm
	var deltaT = (self.rhythm[self.displayIndex] - self.displayTime)
	if deltaT <= self.HIT_TIME:
		self.advanceDisplayNote()
		self.spawnMark()

func spawnMark():
	var mark = DrumMark.instance()
	var x = rand_range(GlobalVars.safe_area.position.x+96, GlobalVars.safe_area.end.x-96)
	var y = rand_range(GlobalVars.safe_area.position.y+400, GlobalVars.safe_area.end.y-400)
	mark.position = Vector2(x, y)
	mark.setParams(self.makeProgress, self.okMsg)
	self.add_child(mark)

# Updates the next note that has to be touched
func advanceNote():
	self.index += 1
	# We repeat the song rhythm
	if self.index == len(self.rhythm):
		self.noteTime = 0
		self.index = 0
