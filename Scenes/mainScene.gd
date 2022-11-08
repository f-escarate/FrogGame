extends Control

onready var gui = $GUI
onready var settings = $GUI/Settings
onready var flow_counter = $GUI/ProgressBar/Label
onready var progressBar = $GUI/ProgressBar
onready var pauseMenu = $GUI/PauseMenu
onready var instrumentSelector = $GUI/Instruments
onready var pivot = $Pivot
onready var particlePivot = $ParticlePivot
onready var musicPlayer = $AudioStreamPlayer
onready var char_position = $Position
onready var mc = $Position/mainCharacter
onready var char_tween = $Position/Tween
onready var currentController = NormalClicker.new(musicPlayer, self)
onready var floatingText = preload("res://Scenes/FloatingText.tscn")
onready var factory = EnemyFactory.new()
onready var explosion = preload("res://effects/explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Scaling to screen size
	self.rect_size = GlobalVars.screen_size
	self.rect_position = GlobalVars.safe_area.position
	
	settings.connect("released", self, "_on_Settings_Pressed")
	pivot.add_child(currentController)
	char_position.add_child(factory)
	
	# Progress Bar values
	self.progressBar.max_value = GlobalVars.maxVal
	self.progressBar.value = GlobalVars.currentVal
	self.refreshProgressText()
	
	self.instrumentSelector.setParams(musicPlayer, self)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currentController.refreshNotes(delta)
	
func _on_Settings_Pressed():
	pauseMenu.pauseGame()

func makeProgress(multiplier = 1):
	
	GlobalVars.currentVal += 1*multiplier
	
	if GlobalVars.currentVal >= GlobalVars.maxVal:
		var wasFighting = GlobalVars.isFighting # tells if the player was fighting before increasing maxVal
		# Returns true if the player has cleared all the phases
		GlobalVars.increaseMaxVal()
		if GlobalVars.isFighting:
			# Go to boss
			self.spawnBoss()
		elif wasFighting and not GlobalVars.isFighting:
			# If the battle has ended, we remove the boss
			self.despawnBoss()
			
		self.progressBar.max_value = GlobalVars.maxVal
		
	
	self.progressBar.value = GlobalVars.currentVal
	self.refreshProgressText()

func refreshProgressText():
	self.flow_counter.text = "{count}/{total}\n".format({"count": GlobalVars.currentVal, "total": GlobalVars.maxVal})
	if GlobalVars.isFighting:
		self.flow_counter.text += "boss battle"
		return
	self.flow_counter.text += "phase: {count}/{total}\n".format({"count": GlobalVars.currentPhase+1, "total": GlobalVars.getTotalPhases()})

func okMsg(msg = "OK!!!"):
	var ftext = floatingText.instance()
	ftext.setText(msg)
	char_position.add_child(ftext)
	
func setController(controller):
	currentController.queue_free()
	currentController = controller
	pivot.add_child(controller)
	
func spawnBoss():
	# Adding the explosion particle
	var explosion1 = explosion.instance()
	particlePivot.add_child(explosion1)
	
	#Creating the enemy and setting the translations with the tween
	factory.createRandomEnemy()
	char_tween.interpolate_property(mc, "position", Vector2(0, 0), Vector2(-200, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	char_tween.interpolate_property(factory, "position", Vector2(0, 0), Vector2(200, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)	
	char_tween.start()

	
func despawnBoss():
	var boss = factory.get_child(0)
	char_tween.interpolate_property(mc, "position", Vector2(-200, 0), Vector2(0, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	char_tween.interpolate_property(boss, "position", Vector2(0, 0), Vector2(400, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)	
	char_tween.connect("tween_all_completed", self, "_removeEnemy", [boss])
	char_tween.start()

func _removeEnemy(enemy):
	factory.removeEnemy(enemy)
	char_tween.disconnect("tween_all_completed", self, "_removeEnemy")
