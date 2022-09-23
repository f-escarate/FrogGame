extends Node2D
class_name Clicker

var musicPlayer : AudioStreamPlayer
var rhythm : Array
var index : int = 0
var displayIndex : int
var bar : Sprite
var barSize : float
const SPEED: float = 1000.0
onready var noteTime: float = 0.0
onready var displayTime: float = 0.0


func _init(player : AudioStreamPlayer):
	# Load rhythm file
	var file = File.new()
	file.open("res://Assets/Songs/KomikuBicycle.tres", File.READ)
	var content = file.get_as_text()
	file.close()
	
	# Create list with the seconds of the rhythm 
	self.rhythm = content.split("\n")
	self.rhythm.pop_back() # Removes the last element, because is a "" string
	# Casting the strings to floats
	for i in range(len(self.rhythm)):
		self.rhythm[i] = float(self.rhythm[i])
	# Set initial values for fields
	self.musicPlayer = player
	# Play the song
	self.musicPlayer.play()
	
	# Bar
	var rhythmBar = preload("res://Scenes/rhythmBar.tscn")
	self.bar = rhythmBar.instance()
	self.add_child(self.bar)
	self.barSize = self.bar.size/2

# It's called every cycle in order to refresh the rhythm
func refreshNotes(delta) -> void:
	# We get the current time	
	self.noteTime += delta
	self.displayTime += delta
	
	# Spawn the marks that show the rhythm
	var deltaX = (self.rhythm[self.displayIndex] - self.displayTime)*self.SPEED
	if deltaX <= self.barSize:
		self.advanceDisplayNote()
		self.bar.rhythmMark(self.SPEED, self.barSize)
	
	# Advance to the next note if the player didn't touch the current one
	var diff = self.rhythm[self.index] - self.noteTime
	if diff < -0.09:
		advanceNote()

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

# Updates the next note that has to be displayed
func advanceDisplayNote():
	self.displayIndex = self.displayIndex+1
	# We repeat the song rhythm
	if self.displayIndex == len(self.rhythm):
		self.displayIndex = 0
		self.displayTime = 0
