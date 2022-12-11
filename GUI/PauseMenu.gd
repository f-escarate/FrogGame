extends MarginContainer

onready var resume = $"%Resume"
onready var credits = $"%CreditsButton"
onready var exit = $"%Exit"
onready var volume = $"%Volume"
onready var creditsGUI = $Credits
onready var mute = $VBoxContainer/Volume2/Button
onready var volumeLevel = -1
onready var isMuted : bool = false
onready var mutedIcon = load("res://images/GUI/volume_off_icon.png")
onready var unmutedIcon = load("res://images/GUI/volume_on_icon.png")

func _ready():
	resume.connect("pressed", self, "_on_resume_pressed")
	credits.connect("pressed", self, "_on_credits_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")
	mute.connect("pressed", self, "_on_mute_pressed")
	volume.connect("value_changed", self, "_on_volume_value_changed")
	hide()
	resume.grab_focus()
	
func _input(event):
	if event.is_action_pressed("menu"):
		self.pauseGame()
		
func _on_resume_pressed():
	hide()
	get_tree().paused = false

func _on_credits_pressed():
	creditsGUI.changeVisibility()
	
func _on_exit_pressed():
	get_tree().quit()
	
func _on_volume_value_changed(value: float):
	self.volumeLevel = linear2db(value)
	self._set_volume(self.volumeLevel)
	self.isMuted = false
	mute.icon = unmutedIcon
	
func _on_mute_pressed():
	if isMuted:
		# Unmute
		self._set_volume(self.volumeLevel)
		mute.icon = unmutedIcon
	else:
		# Mute
		self._set_volume(-INF)
		mute.icon = mutedIcon
	self.isMuted = !self.isMuted
	
func pauseGame():
	visible = !visible
	get_tree().paused = visible

func _set_volume(vol):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		vol)
