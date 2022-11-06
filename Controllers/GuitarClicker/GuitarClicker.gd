extends Clicker
class_name GuitarClicker

var guitarGUI : Node2D
const SPEED : float = 300.0

func _init(player, aMain).(player, aMain):
	self.rhythm = getRhythmListFromFile("res://Assets/Songs/KomikuNotAClubEdited.tres")
	self.musicPlayer.stream = load("res://Assets/Songs/KomikuNotAClubEdited.mp3")
	self.musicPlayer.play()
		
	# Guitar GUI
	var guitarBars = preload("res://Controllers/GuitarClicker/GuitarBars.tscn")
	self.guitarGUI = guitarBars.instance()
	self.guitarGUI.position = Vector2(GlobalVars.width/2, 8*GlobalVars.height/10)
	self.add_child(self.guitarGUI)
	self.guitarGUI.setParams(aMain)
	
func _ready():
	# Setting initial time
	self.displayTime = 0
	# Getting the time requiered to travel along the bar
	var requiredTime = self.guitarGUI.depth/self.SPEED
	
	# Spawning the initial marks (those who don't spawn at the top of the bar)
	var currentTime = self.rhythm[self.displayIndex]
	while currentTime < requiredTime:
		var yPos = currentTime*self.SPEED
		self.guitarGUI.addMark(self.SPEED, self.displayIndex, yPos)
		self.advanceDisplayNote()
		currentTime = self.rhythm[self.displayIndex]
	

func refreshNotes(delta):
	# We get the current time
	self.displayTime += delta
	
	# Spawn the marks that show the rhythm
	var deltaX = (self.rhythm[self.displayIndex] - self.displayTime) * self.SPEED
	if deltaX <= self.guitarGUI.depth:
		self.guitarGUI.addMark(self.SPEED, self.displayIndex)
		self.advanceDisplayNote()
	
