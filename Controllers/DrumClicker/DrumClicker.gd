extends Clicker
class_name DrumClicker

const HIT_TIME: float = GlobalVars.DRUM_HIT_TIME
onready var DrumMark = preload("res://Controllers/DrumClicker/DrumMark.tscn")
const CIRCLE_RADIUS = 48
const BACK_CIRCLE_RADIUS = 64
var circles_container : Node2D
var makeProgress
var restorePosRef
var okMsg
var grid : Array
var numXpos : int
var numYpos : int
var diameter

func _init(player, main).(player, main):
	self.setSong("KomikuBicycle")
	
	# Func refs
	self.makeProgress = funcref(self.main, "makeProgress")
	self.okMsg = funcref(self.main, "okMsg")
	self.restorePosRef = funcref(self, "restorePos")
	
	self.circles_container = Node2D.new()
	self.add_child(circles_container)
		
func _ready():
	# Get initial display time
	self.displayTime = 0
	
	# Creating the grid
	var width = GlobalVars.width + CIRCLE_RADIUS - 5
	var height = 13*GlobalVars.height/20 + CIRCLE_RADIUS
	self.diameter = 2*self.BACK_CIRCLE_RADIUS
	self.numXpos = floor(width/diameter)
	self.numYpos = floor(height/diameter)
	
	var restX : float = (width%self.diameter)/self.numXpos
	var restY : float = (height%self.diameter)/self.numYpos
	self.diameter += min(restX,restY)
	
	# Creating a matrix of positions for the grid
	for i in range(self.numXpos):
		self.grid.append([])
		for j in range(self.numYpos):
			self.grid[i].append(0)
	
	# Spawning the initial marks
	var currentTime = self.rhythm[self.displayIndex]
	while currentTime < self.HIT_TIME:
		self.spawnMark(self.HIT_TIME-currentTime)
		self.advanceDisplayNote()
		currentTime = self.rhythm[self.displayIndex]
	
	

# It's called every cycle in order to refresh the rhythm
func refreshNotes() -> void:
	# We get the current time
	self.displayTime = musicPlayer.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	
	# If we have gone over all the notes of the song, we have to handle the music restart cycle
	if self.displayTime > rhythm[len(rhythm)-1] - self.HIT_TIME:
		# If the current note time is one of the firsts times on the rhythm list
		#  we subtract the song length to the display time
		if self.rhythm[self.displayIndex] < self.rhythm[len(rhythm)-1]:
			self.displayTime -= self.songLength
	
	# Spawn the marks that show the rhythm
	var deltaT = (self.rhythm[self.displayIndex] - self.displayTime)
	if deltaT <= self.HIT_TIME:
		self.spawnMark()
		self.advanceDisplayNote()
		
# Spawns a mark considering its elapsed time since is supposed to be spawned
func spawnMark(lifeTime = 0.0):
	var candidate_position = null
	var gridPos = null
	
	# Generating a random position for the mark considering the grid 
	#  (to avoid superpositions between the marks)
	var i = 0
	while candidate_position == null or i > self.numXpos * self.numYpos:
		var x = randi()%self.numXpos
		var y = randi()%self.numYpos
		if self.grid[x][y] == 0:
			self.grid[x][y] = 1
			gridPos = Vector2(x,y)
			x = x*self.diameter + CIRCLE_RADIUS
			y = y*self.diameter + 3*GlobalVars.height/20 + CIRCLE_RADIUS
			candidate_position = Vector2(x, y)
	
	# If is still null, is because all the positions are used by another mark
	if candidate_position == null:
		return
	
	var mark = DrumMark.instance()
	mark.position = candidate_position
	mark.setParams(self.makeProgress, self.okMsg, self.restorePosRef, (self.displayIndex)%13, gridPos, lifeTime)
	self.circles_container.add_child(mark)
	
# Restores a position in the grid to be used by another mark
# 	That function is called when a mark disappears
func restorePos(pos):
	self.grid[pos.x][pos.y] = 0
	
