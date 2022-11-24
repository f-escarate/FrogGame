extends Clicker
class_name GuitarClicker

var guitarGUI : Node2D
const SPEED : float = 300.0
var travelTime # the time needed to travel along the bar

func _init(player, aMain).(player, aMain):
	self.setSong("KomikuNotAClubEdited")
		
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
	self.travelTime = self.guitarGUI.depth/self.SPEED
	
	# Spawning the initial marks (those who don't spawn at the top of the bar)
	var currentTime = self.rhythm[self.displayIndex]
	while currentTime < self.travelTime:
		var yPos = currentTime*self.SPEED
		self.guitarGUI.addMark(self.SPEED, self.displayIndex, yPos)
		self.advanceDisplayNote()
		currentTime = self.rhythm[self.displayIndex]
	

func refreshNotes():
	# We get the current time
	self.displayTime = musicPlayer.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	
	# If we have gone over all the notes of the song, we have to handle the music restart cycle
	if self.displayTime > self.rhythm[len(rhythm)-1] - self.travelTime:
		# If the current note time is one of the firsts times on the rhythm list
		#  we subtract the song length to the display time
		if self.rhythm[self.displayIndex] < self.rhythm[len(rhythm)-1]:
			self.displayTime -= self.songLength
	
	# Spawn the marks that show the rhythm
	var deltaX = (self.rhythm[self.displayIndex] - self.displayTime) * self.SPEED
	if deltaX <= self.guitarGUI.depth:
		self.guitarGUI.addMark(self.SPEED, self.displayIndex)
		self.advanceDisplayNote()
	
