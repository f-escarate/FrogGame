extends Control

onready var gui = $GUI
onready var settings = $GUI/Settings
onready var flow_counter = $GUI/Label
onready var progressBar = $GUI/ProgressBar
onready var pauseMenu = $GUI/PauseMenu
onready var pivot = $Pivot
onready var musicPlayer = $AudioStreamPlayer
onready var mc = $mainCharacter
onready var currentController = NormalClicker.new(musicPlayer, self)
onready var floatingText = preload("res://Scenes/FloatingText.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	# Scaling to screen size
	self.rect_size = GlobalVars.screen_size
	self.rect_position = GlobalVars.safe_area.position
	
	settings.connect("pressed", self, "_on_Settings_Pressed")
	addController(currentController)
	
	self.progressBar.max_value = GlobalVars.maxVal
	self.progressBar.value = GlobalVars.currentVal

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currentController.refreshNotes(delta)
	
func _on_Settings_Pressed():
	pauseMenu.pauseGame()


func makeProgress(multiplier = 1):
	
	GlobalVars.currentVal += 1*multiplier
	
	if GlobalVars.currentVal >= GlobalVars.maxVal:
		# Returns true if the player has cleared all the phases
		if GlobalVars.increaseMaxVal():
			mc.playGuitar()
			currentController.queue_free()	
			
			currentController = GuitarClicker.new(musicPlayer, self)
			addController(currentController)
		self.progressBar.max_value = GlobalVars.maxVal
		
	
	self.progressBar.value = GlobalVars.currentVal
	self.flow_counter.text = "hits: {count}/{total}\n".format({"count": GlobalVars.currentVal, "total": GlobalVars.maxVal})
	self.flow_counter.text += "current phase: {count}/{total}\n".format({"count": GlobalVars.currentPhase+1, "total": GlobalVars.NUMPHASES})

func okMsg(msg = "OK!!!"):
	var ftext = floatingText.instance()
	ftext.setText(msg)
	gui.add_child(ftext)

func addController(controller):
	pivot.add_child(controller)
	
	
