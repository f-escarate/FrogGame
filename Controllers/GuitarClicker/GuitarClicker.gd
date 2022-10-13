extends Clicker
class_name GuitarClicker

var guitarGUI : Node2D
const SPEED : float = 200.0

func _init(player, aMain).(player, aMain):
	self.rhythm = getRhythmListFromFile("res://Assets/Songs/KomikuNotAClub.tres") # poner otro archivo de musica
	self.musicPlayer.stream = load("res://Assets/Songs/KomikuNotAClub.mp3")
	self.musicPlayer.play()
	
	# Guitar GUI
	var guitarBars = preload("res://Controllers/GuitarClicker/GuitarBars.tscn")
	self.guitarGUI = guitarBars.instance()
	self.guitarGUI.position = Vector2(GlobalVars.width/2, 9*GlobalVars.height/10)
	self.add_child(self.guitarGUI)
	self.guitarGUI.setParams(aMain)

func refreshNotes(delta):
	# We get the current time	
	self.displayTime += delta
	
	# Spawn the marks that show the rhythm
	var deltaX = (self.rhythm[self.displayIndex] - self.displayTime) * self.SPEED
	if deltaX <= self.guitarGUI.depth:
		self.guitarGUI.addMark(self.SPEED, self.displayIndex)
		self.advanceDisplayNote()
	
