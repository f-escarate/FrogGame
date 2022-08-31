extends Node
class_name Clicker

var time0 : float # initial time, in microseconds
var deltaT : float # difference between the current time and time0, in seconds
var musicPlayer : AudioStreamPlayer
var rhythm : Array
var index : int

func _init(player : AudioStreamPlayer):
	# Load rhythm file
	var file = File.new()
	file.open("res://Assets/Songs/KomikuBicycle.rhythm", File.READ)
	var content = file.get_as_text()
	file.close()
	self.rhythm = content.split("\n")
	for i in range(len(self.rhythm)):
		self.rhythm[i] = float(self.rhythm[i])
	
	self.time0 = OS.get_ticks_usec()
	self.musicPlayer = player
	self.musicPlayer.play()

# It's called every cycle in order to refresh the rhythm
func refreshNotes(label: Label) -> void:
	var timef = OS.get_ticks_usec()
	self.deltaT = (timef - time0) / 1000000.0 # We transform it to seconds
	var diff = self.rhythm[self.index] - deltaT
	label.text = str(diff)
	if diff < -0.1:
		advanceNote()

# Receives an InputEventScreenTouch and returns a boolean that is true if the player has reached the rhythm and false if not
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
