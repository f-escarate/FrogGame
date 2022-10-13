extends Clicker
class_name GuitarClicker

var guitarGUI : Node2D
const SPEED : float = 300.0

func _init(player, aMain).(player, aMain):
	self.rhythm = getRhythmListFromFile("res://Assets/Songs/KomikuNotAClub.tres") # poner otro archivo de musica
	self.musicPlayer.stream = load("res://Assets/Songs/KomikuNotAClub.mp3")
	self.musicPlayer.play()
		
	# Guitar GUI
	var guitarBars = preload("res://Controllers/GuitarClicker/GuitarBars.tscn")
	self.guitarGUI = guitarBars.instance()
	self.guitarGUI.position = Vector2(GlobalVars.width/2, 19*GlobalVars.height/20)
	self.add_child(self.guitarGUI)
	self.guitarGUI.setParams(aMain)
	
func _ready():
	# Get initial time
	var requiredTime = self.guitarGUI.depth/self.SPEED
	self.displayTime = self.rhythm[0]-requiredTime

func refreshNotes(delta):
	# We get the current time	
	self.displayTime += delta
	
	# Spawn the marks that show the rhythm
	var deltaX = (self.rhythm[self.displayIndex] - self.displayTime) * self.SPEED
	if deltaX <= self.guitarGUI.depth:
		self.guitarGUI.addMark(self.SPEED, self.displayIndex)
		self.advanceDisplayNote()
	
