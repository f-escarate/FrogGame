extends Node2D
class_name Clicker

var musicPlayer : AudioStreamPlayer
var rhythm : Array
var songLength : float
var displayIndex : int
onready var displayTime: float = 0.0
var main

func _init(player : AudioStreamPlayer, aMain):
	# Set initial values for fields
	self.musicPlayer = player
	self.main = aMain
	
	# creating a button to click
	var button = Button.new()
	button.margin_right = GlobalVars.width
	button.margin_bottom = GlobalVars.height
	button.modulate = Color(0,0,0,0)
	button.connect("pressed", self, "isPressed")
	self.add_child(button)

# It's called every cycle in order to refresh the rhythm
func refreshNotes() -> void:
	pass
	
func isPressed():
	#self.main.makeProgress()
	pass

# Updates the next note that has to be displayed
func advanceDisplayNote():
	self.displayIndex = (self.displayIndex+1)%len(self.rhythm)
		
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

func setSong(song_name):
	self.rhythm = getRhythmListFromFile("res://Assets/Songs/%s.tres" % song_name)
	var song : AudioStream = load("res://Assets/Songs/%s.mp3" % song_name)
	self.musicPlayer.stream = song
	self.songLength = song.get_length()
	self.musicPlayer.play()
