extends Clicker
class_name DrumClicker

const HIT_TIME: float = GlobalVars.DRUM_HIT_TIME
onready var DrumMark = preload("res://Controllers/DrumClicker/DrumMark.tscn")
var makeProgress
var okMsg

func _init(player, main).(player, main):
	self.setSong("KomikuBicycle")
	
	# Func refs
	self.makeProgress = funcref(self.main, "makeProgress")
	self.okMsg = funcref(self.main, "okMsg")
		
func _ready():
	# Get initial display time
	self.displayTime = 0

# It's called every cycle in order to refresh the rhythm
func refreshNotes() -> void:
	# We get the current time
	self.displayTime = musicPlayer.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	
	# If we have gone over all the notes of the song, we have to handle the music restart cycle
	if self.displayTime > rhythm[len(rhythm)-1] - self.HIT_TIME:
		# If the current note time is one of the firsts times on the rhythm list
		#  we subtract the song length to the display time
		if self.rhythm[self.displayIndex] < self.rhythm[len(rhythm)-1]:
			self.displayTime -= self.songLength
	
	# Spawn the marks that show the rhythm
	var deltaT = (self.rhythm[self.displayIndex] - self.displayTime)
	if deltaT <= self.HIT_TIME:
		self.advanceDisplayNote()
		self.spawnMark()

func spawnMark():
	var mark = DrumMark.instance()
	var x = rand_range(64, GlobalVars.width-64)
	var y = rand_range(3*GlobalVars.height/20 + 64, 8*GlobalVars.height/10-64)
	mark.position = Vector2(x, y)
	mark.setParams(self.makeProgress, self.okMsg)
	self.add_child(mark)
