extends Clicker
class_name GuitarClicker

func _init(player).(player):
	self.rhythm = getRhythmListFromFile("res://Assets/Songs/KomikuNotAClub.tres") # poner otro archivo de musica
	self.musicPlayer.stream = load("res://Assets/Songs/KomikuNotAClub.mp3")
	self.musicPlayer.play()
	noteTime = 0.0

func refreshNotes(delta):
	pass
