extends Clicker
class_name NormalClicker

var bar : Sprite
var barSize : float
const SPEED: float = 2000.0
var index : int = 0
onready var noteTime: float = 0.0

func _init(player, main).(player, main):
	self.rhythm = getRhythmListFromFile("res://Assets/Songs/KomikuBicycle.tres")
	# Play the song
	self.musicPlayer.play()
	
	# creating a button to click
	var button = Button.new()
	button.margin_right = GlobalVars.width
	button.margin_bottom = GlobalVars.height
	button.modulate = Color(0,0,0,0)
	button.connect("pressed", self, "isPressed")
	self.add_child(button)
		
	# Bar
	var rhythmBar = preload("res://Controllers/NormalClicker/rhythmBar.tscn")
	self.bar = rhythmBar.instance()
	self.bar.position = Vector2(GlobalVars.width/2, GlobalVars.height/10)
	self.add_child(self.bar)
	self.barSize = self.bar.size/2

func _ready():
	# Get initial display time
	var requiredTime = self.barSize/self.SPEED
	self.displayTime = self.rhythm[0]-requiredTime

# It's called every cycle in order to refresh the rhythm
func refreshNotes(delta) -> void:
	# We get the current time	
	self.noteTime += delta
	self.displayTime += delta
	
	# Spawn the marks that show the rhythm
	var deltaX = (self.rhythm[self.displayIndex] - self.displayTime) * self.SPEED
	if deltaX <= self.barSize:
		self.advanceDisplayNote()
		self.bar.rhythmMark(self.SPEED, self.barSize)
	
	# Advance to the next note if the player didn't touch the current one
	var diff = self.rhythm[self.index] - self.noteTime
	if diff < -GlobalVars.GOOD_HIT:
		advanceNote()

# Updates the next note that has to be touched
func advanceNote():
	self.index += 1
	# We repeat the song rhythm
	if self.index == len(self.rhythm):
		self.noteTime = 0
		self.index = 0
			
func isPressed():		
	if self.rhythm[self.index] - self.noteTime < 0.09:
		advanceNote()
		self.main.makeProgress()
		self.main.okMsg()
		return true
	return false
