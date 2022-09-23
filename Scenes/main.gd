extends Node2D

onready var settings = $Settings
onready var flow_counter = $Label
onready var musicPlayer = $AudioStreamPlayer
onready var progressBar = $ProgressBar
onready var pauseMenu = $PauseMenu
onready var currentController = Clicker.new(musicPlayer)
onready var isButtonPressed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	settings.connect("pressed", self, "_on_Settings_Pressed")
	add_child(currentController)
	currentController.global_position = $Pivot.global_position
	self.progressBar.max_value = GlobalVars.maxVal
	self.progressBar.value = GlobalVars.currentVal

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currentController.refreshNotes(delta)

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		# If there is a button being pressed, nothing happens
		if isButtonPressed:
			isButtonPressed = false
			return		
		var hasRhythm: bool = currentController.hasRhythm(event)
		if hasRhythm:
			self.makeProgress()
			self.flow_counter.text = "hits: {count}/{total}".format({"count": GlobalVars.currentVal, "total": GlobalVars.maxVal})
			

func _on_Settings_Pressed():
	isButtonPressed = true
	pauseMenu.pauseGame()

func makeProgress():
	if self.progressBar.value == GlobalVars.maxVal:
		GlobalVars.increaseMaxVal()
		self.progressBar.max_value = GlobalVars.maxVal
	GlobalVars.currentVal += 1
	self.progressBar.value = GlobalVars.currentVal
	
