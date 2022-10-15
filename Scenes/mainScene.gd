extends Control

onready var gui = $GUI
onready var settings = $GUI/Settings
onready var flow_counter = $GUI/Label
onready var progressBar = $GUI/ProgressBar
onready var pauseMenu = $GUI/PauseMenu
onready var instrumentSelector = $GUI/Instruments
onready var pivot = $Pivot
onready var musicPlayer = $AudioStreamPlayer
onready var char_position = $Position
onready var mc = $Position/mainCharacter
onready var char_tween = $Position/Tween
onready var currentController = NormalClicker.new(musicPlayer, self)
onready var floatingText = preload("res://Scenes/FloatingText.tscn")
onready var factory = EnemyFactory.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Scaling to screen size
	self.rect_size = GlobalVars.screen_size
	self.rect_position = GlobalVars.safe_area.position
	
	settings.connect("pressed", self, "_on_Settings_Pressed")
	pivot.add_child(currentController)
	char_position.add_child(factory)
	
	self.progressBar.max_value = GlobalVars.maxVal
	self.progressBar.value = GlobalVars.currentVal
	
	self.instrumentSelector.setParams(musicPlayer, self)

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
			# Go to boss
			self.spawnBoss()
			
		self.progressBar.max_value = GlobalVars.maxVal
		
	
	self.progressBar.value = GlobalVars.currentVal
	self.flow_counter.text = "hits: {count}/{total}\n".format({"count": GlobalVars.currentVal, "total": GlobalVars.maxVal})
	self.flow_counter.text += "current phase: {count}/{total}\n".format({"count": GlobalVars.currentPhase+1, "total": GlobalVars.NUMPHASES})

func okMsg(msg = "OK!!!"):
	var ftext = floatingText.instance()
	ftext.setText(msg)
	gui.add_child(ftext)
	
func setController(controller):
	currentController.queue_free()
	currentController = controller
	pivot.add_child(controller)
	
func spawnBoss():
	factory.createWitch()
	char_tween.interpolate_property(mc, "position", Vector2(0, 0), Vector2(-200, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	char_tween.interpolate_property(factory, "position", Vector2(0, 0), Vector2(200, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)	
	char_tween.start()
