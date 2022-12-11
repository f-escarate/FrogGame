extends Control

onready var settings = $GUI/Settings
onready var flow_counter = $GUI/ProgressBar/Label
onready var progressBar = $GUI/ProgressBar
onready var pauseMenu = $GUI/PauseMenu
onready var instrumentSelector = $GUI/Instruments
onready var money_quantity = $GUI/MoneyGUI/MoneyQuantity
onready var store = $GUI/tienda
onready var pivot = $Pivot
onready var particlePivot = $ParticlePivot
onready var musicPlayer = $AudioStreamPlayer
onready var char_position = $Position
onready var mc = $Position/mainCharacter
onready var char_tween = $Position/Tween
onready var fans = $Fans
onready var currentController = NormalClicker.new(musicPlayer, self)
onready var factory = EnemyFactory.new()
onready var floatingText = preload("res://effects/FloatingText.tscn")
onready var explosion = preload("res://effects/explosion.tscn")
onready var bossCountdown = preload("res://GUI/BossCountdown.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Scaling to screen size
	self.rect_size = GlobalVars.screen_size
	self.rect_position = GlobalVars.safe_area.position
	
	settings.connect("released", self, "_on_Settings_Pressed")
	pivot.add_child(currentController)
	char_position.add_child(factory)
	
	# Progress Bar values
	self.progressBar.max_value = GlobalVars.progressLimit
	self.progressBar.value = GlobalVars.progressValue
	self.refreshProgressText()
	
	# Money values
	self.refreshMoneyGUI()
	
	# Setting global function references
	GlobalVars.refreshMoneyGUI = funcref(self, "refreshMoneyGUI")	# For refreshing the money
	Instruments.refreshInstruments = funcref(instrumentSelector, "show_unlocked_instruments")
	GlobalVars.fanGUIRefresh_fun_ref = funcref(self, "refreshFansGUI")	# For refreshing the fans
	
	self.instrumentSelector.setParams(musicPlayer, self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.currentController.refreshNotes()
	
func _on_Settings_Pressed():
	pauseMenu.pauseGame()

func makeProgress(multiplier = 1):
	GlobalVars.increaseProgressValue(multiplier)
	# If the progress exceeds the limit, then the limit is increased
	if GlobalVars.progressValue >= GlobalVars.progressLimit:
		var wasFighting = GlobalVars.isFighting # tells if the player was fighting before increasing progressLimit
		# Returns true if the player has cleared all the phases
		GlobalVars.increaseProgressLimit()
		if GlobalVars.isFighting:
			self.spawnBoss() # Go to boss
		elif wasFighting and not GlobalVars.isFighting:
			# If the battle has ended, we remove the boss
			self.despawnBoss()
			GlobalVars.lvlUp() # Increasing the level
			self.winMsg()
			
		self.progressBar.max_value = GlobalVars.progressLimit
		
		GlobalVars.earnMoney()
		self.refreshMoneyGUI()
	
	# Saving progress
	GlobalVars.save_data()
	self.progressBar.value = GlobalVars.progressValue
	self.refreshProgressText()

func refreshProgressText():
	self.flow_counter.text = "{count}/{total}\n".format({"count": GlobalVars.progressValue, "total": GlobalVars.progressLimit})
	if GlobalVars.isFighting:
		self.flow_counter.text += "boss battle"
		return
	self.flow_counter.text += "phase: {count}/{total}\n".format({"count": GlobalVars.currentPhase+1, "total": GlobalVars.getTotalPhases()})

func okMsg(msg = "OK!!!"):
	var ftext = floatingText.instance()
	ftext.setText(msg)
	ftext.setPosition(Vector2(0, -GlobalVars.height/4))
	char_position.add_child(ftext)

func winMsg():
	var ftext = floatingText.instance()
	ftext.setText("You have won the\n music battle !!!")
	
	ftext.setTimes(0.3, 1, 0.3)
	particlePivot.add_child(ftext)
	
func setController(controller):
	currentController.queue_free()
	currentController = controller
	pivot.add_child(controller)
	
func spawnBoss():
	# Creating the enemy
	var enemyType : int = factory.createRandomEnemy()
	
	# Adding boss countdown
	var countdown = bossCountdown.instance()
	var fun_ref = funcref(self, "_defeat")
	countdown.setDefeatFun(fun_ref)
	countdown.position = Vector2(progressBar.rect_size.x, 50)
	progressBar.add_child(countdown)
	
	# Adding the explosion particle
	var explosionParticle = explosion.instance()
	explosionParticle.setEnemyType(enemyType)
	particlePivot.add_child(explosionParticle)
	
	# Setting the translations with the tween
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
	self.store.update_store()
	char_tween.disconnect("tween_all_completed", self, "_removeEnemy")

func refreshMoneyGUI():
	self.money_quantity.text = str(GlobalVars.totalMoney) + "$"

# Function called when the player is defeated by a boss
func _defeat():
	despawnBoss()
	# Updating progress
	GlobalVars.isFighting = false		# Ending fight
	GlobalVars.refreshProgress()		# Going to 0 phase
	GlobalVars.progressValue = 0		# Setting progress to 0
	# Refreshing GUI
	self.progressBar.value = GlobalVars.progressValue
	self.progressBar.max_value = GlobalVars.progressLimit
	self.refreshProgressText()
	# Defeat text
	var ftext = floatingText.instance()
	if GlobalVars.fansNumber:
		ftext.setText("You have been defeated\n One fan has gone")
	else:
		ftext.setText("You have been defeated\n You don't have fans that\n could be dissapointed")
	ftext.setColor(Color(1,0,0))
	ftext.setTimes(0.3, 2, 0.3)
	particlePivot.add_child(ftext)
	# Fan remove
	GlobalVars.addFans(-1)
	

func refreshFansGUI():
	self.fans.refresh()
