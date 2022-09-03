extends Node2D
class_name Clicker

var time0 : float # initial time, in microseconds
var displayTime0 : float # initial time, in microseconds is used to display the bars
var deltaT : float # difference between the current time and time0, in seconds
var displayDeltaT : float # difference between the time and displayTime0, in seconds
var musicPlayer : AudioStreamPlayer
var rhythm : Array
var index : int = 0
var displayIndex : int
var bar : Sprite
var barSize : float
const SPEED: float = 1000.0

func _init(player : AudioStreamPlayer):
	# Load rhythm file
	var file = File.new()
	file.open("res://Assets/Songs/KomikuBicycle.rhythm", File.READ)
	var content = file.get_as_text()
	file.close()
	
	# Create list with the seconds of the rhythm 
	self.rhythm = content.split("\n")
	for i in range(len(self.rhythm)):
		self.rhythm[i] = float(self.rhythm[i])
	
	# Set initial values for fields
	self.time0 = OS.get_ticks_usec()
	self.displayTime0 = self.time0
	self.musicPlayer = player
	# Play the song
	self.musicPlayer.play()
	
	# Bar
	var rhythmBar = preload("res://Scenes/rhythmBar.tscn")
	self.bar = rhythmBar.instance()
	self.add_child(self.bar)
	self.barSize = self.bar.size/2

# It's called every cycle in order to refresh the rhythm
func refreshNotes() -> void:
	# We get the current time
	var timef = OS.get_ticks_usec()
	
	# Spawn the marks that show the rhythm
	self.displayDeltaT = (timef - self.displayTime0) / 1000000.0 # We transform it to seconds
	var deltaX = (self.rhythm[self.displayIndex] - self.displayDeltaT)*self.SPEED
	if deltaX <= self.barSize:
		self.advanceDisplayNote()
		self.bar.rhythmMark(self.SPEED, self.barSize)
	
	# Advance to the next note if the player didn't touch the current one
	self.deltaT = (timef - time0) / 1000000.0 # We transform it to seconds
	var diff = self.rhythm[self.index] - deltaT
	if diff < -0.1:
		advanceNote()

# Receives an InputEventScreenTouch and returns a boolean that is true if the player has reached the rhythm and false if not
# warning-ignore:unused_argument
func hasRhythm(event: InputEventScreenTouch) -> bool:
	if self.rhythm[self.index] - self.deltaT < 0.1:
		advanceNote()
		print("OK",self.index)
		return true
	return false

# Updates the next note that has to be touched
func advanceNote():
	self.index += 1
	# We repeat the song rhythm
	if self.index == len(self.rhythm):
		self.time0 = OS.get_ticks_usec()
		self.index = 0

# Updates the next note that has to be displayed
func advanceDisplayNote():
	# We repeat the song rhythm
	if self.displayIndex == len(self.rhythm) - 1:
		self.displayTime0 = OS.get_ticks_usec()
		self.displayIndex = 0
	else:
		self.displayIndex = self.displayIndex+1
