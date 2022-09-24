extends Clicker
class_name GuitarClicker

var guitarGUI : Node2D

func _init(player).(player):
	self.rhythm = getRhythmListFromFile("res://Assets/Songs/KomikuNotAClub.tres") # poner otro archivo de musica
	self.musicPlayer.stream = load("res://Assets/Songs/KomikuNotAClub.mp3")
	self.musicPlayer.play()
	noteTime = 0.0
	
	# Guitar GUI
	var guitarBars = preload("res://Controllers/GuitarClicker/GuitarBars.tscn")
	self.guitarGUI = guitarBars.instance()
	self.add_child(self.guitarGUI)

func refreshNotes(delta):
	pass
