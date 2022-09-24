extends Node2D
class_name Clicker

var musicPlayer : AudioStreamPlayer
var rhythm : Array
var index : int = 0
onready var noteTime: float = 0.0


func _init(player : AudioStreamPlayer):
	# Set initial values for fields
	self.musicPlayer = player

# It's called every cycle in order to refresh the rhythm
func refreshNotes(delta) -> void:
	pass

# Receives an InputEventScreenTouch and returns a boolean that is true if the player has reached the rhythm and false if not
# warning-ignore:unused_argument
func hasRhythm(event: InputEventScreenTouch) -> bool:
	if self.rhythm[self.index] - self.noteTime < 0.09:
		advanceNote()
		return true
	return false

# Updates the next note that has to be touched
func advanceNote():
	self.index += 1
	# We repeat the song rhythm
	if self.index == len(self.rhythm):
		self.noteTime = 0
		self.index = 0

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
