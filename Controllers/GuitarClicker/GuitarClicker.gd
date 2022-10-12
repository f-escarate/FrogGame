extends Clicker
class_name GuitarClicker

var guitarGUI : Node2D
const SPEED : float = 1000.0

func _init(player, aMain).(player, aMain):
	self.rhythm = getRhythmListFromFile("res://Assets/Songs/KomikuNotAClub.tres") # poner otro archivo de musica
	self.musicPlayer.stream = load("res://Assets/Songs/KomikuNotAClub.mp3")
	self.musicPlayer.play()
	noteTime = 0.0
	
	# Guitar GUI
	var guitarBars = preload("res://Controllers/GuitarClicker/GuitarBars.tscn")
	self.guitarGUI = guitarBars.instance()
	self.guitarGUI.position = Vector2(GlobalVars.width/2, 9*GlobalVars.width/10)
	self.add_child(self.guitarGUI)
	self.guitarGUI.setParams(self, aMain)

func refreshNotes(delta):
	# We get the current time	
	self.noteTime += delta
	self.displayTime += delta
	
	# Spawn the marks that show the rhythm
	var deltaX = (self.rhythm[self.displayIndex] - self.displayTime) * self.SPEED
	if deltaX <= self.guitarGUI.depth:
		self.guitarGUI.addMark(self.SPEED, self.displayIndex)
		self.advanceDisplayNote()
	
	# Advance to the next note if the player didn't touch the current one
	var diff = self.rhythm[self.index] - self.noteTime
	if diff < -GlobalVars.GOOD_HIT:
		advanceNote()

