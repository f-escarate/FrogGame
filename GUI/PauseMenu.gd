extends MarginContainer

onready var resume = $"%Resume"
onready var exit = $"%Exit"
onready var volume = $"%Volume"
func _ready():
	resume.connect("pressed", self, "_on_resume_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")
	volume.connect("value_changed", self, "_on_volume_value_changed")
	hide()
	
	resume.grab_focus()
func _input(event):
	if event.is_action_pressed("menu"):
		self.pauseGame()
		
func _on_resume_pressed():
	hide()
	get_tree().paused = false
func _on_exit_pressed():
	get_tree().quit()
func _on_volume_value_changed(value: float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear2db(value)
	)

func pauseGame():
	visible = !visible
	get_tree().paused = visible
