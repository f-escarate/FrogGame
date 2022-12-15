extends Clicker
class_name NormalClicker

var bar : Sprite
var barSize : float
const SPEED: float = 2000.0
var index : int = 0
onready var noteTime: float = 0.0
onready var t0 : float = 0.0
var requiredTime

func _init(player, main).(player, main):
	self.setSong("KomikuBicycle")
		
	# Bar
	var rhythmBar = preload("res://Controllers/NormalClicker/rhythmBar.tscn")
	self.bar = rhythmBar.instance()
	self.bar.position = Vector2(GlobalVars.width/2, GlobalVars.height/10)
	self.add_child(self.bar)
	self.barSize = self.bar.size/2

func _ready():
	# Get initial display time
	self.requiredTime = self.barSize/self.SPEED
	self.displayTime = self.rhythm[0]-requiredTime

# It's called every cycle in order to refresh the rhythm
func refreshNotes() -> void:
	# We get the current time
	var tf = musicPlayer.get_playback_position()
	var delta = tf - t0
	self.t0 = tf
	delta = delta + self.songLength if delta < 0 else delta
	self.noteTime += delta
	
	# Getting the displayTime
	self.displayTime = tf + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	# If we have gone over all the notes of the song, we have to handle the music restart cycle
	if self.displayTime > self.rhythm[len(rhythm)-1] - self.requiredTime:
		# If the current note time is one of the firsts times on the rhythm list
		#  we subtract the song length to the display time
		if self.rhythm[self.displayIndex] < self.rhythm[len(rhythm)-1]:
			self.displayTime -= self.songLength
	
	# Spawn the marks that show the rhythm
	var deltaX = (self.rhythm[self.displayIndex] - self.displayTime) * self.SPEED
	if deltaX <= self.barSize:
		self.advanceDisplayNote()
		self.bar.rhythmMark(self.SPEED, self.barSize)
	
	# Advance to the next note if the player didn't touch the current one
	var diff = self.rhythm[self.index] - self.noteTime
	if diff < -GlobalVars.GOOD_HIT:
		GlobalVars.comboCount = 0
		advanceNote()

# Updates the next note that has to be touched
func advanceNote():
	self.index += 1
	# We repeat the song rhythm
	if self.index == len(self.rhythm):
		self.noteTime = 0
		self.index = 0
			
func isPressed():		
	if self.rhythm[self.index] - self.noteTime < GlobalVars.GOOD_HIT:
		GlobalVars.comboCount += 1
		self.main.comboMsg()
		advanceNote()
		self.main.makeProgress(Instruments.instruments_click_progress[Instruments.MIC])
		self.main.okMsg()
		return
	
