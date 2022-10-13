extends Node2D
class_name Clicker

var musicPlayer : AudioStreamPlayer
var rhythm : Array
var displayIndex : int
onready var displayTime: float = 0.0
var main

func _init(player : AudioStreamPlayer, aMain):
	# Set initial values for fields
	self.musicPlayer = player
	self.main = aMain

# It's called every cycle in order to refresh the rhythm
func refreshNotes(delta) -> void:
	pass

# Updates the next note that has to be displayed
func advanceDisplayNote():
	self.displayIndex = self.displayIndex+1
	# We repeat the song rhythm
	if self.displayIndex == len(self.rhythm):
		self.displayIndex = 0
		self.displayTime -= self.rhythm[len(self.rhythm)-1]
		
func getRhythmListFromFile(filePath):
	# Load rhythm file
	var file = File.new()
	file.open(filePath, File.READ)
	var content = file.get_as_text()
	file.close()
	# Create list with the seconds of the rhythm 
	var rhythm: Array = content.split("\n")
	rhythm.pop_back() # Removes the last element, because is a "" string
	# Casting the strings to floats
	for i in range(len(rhythm)):
		rhythm[i] = float(rhythm[i])
	return rhythm
