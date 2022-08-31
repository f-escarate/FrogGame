extends Node2D

onready var settings = $Settings
onready var musicPlayer = $AudioStreamPlayer
onready var currentController = Clicker.new(musicPlayer)
onready var isButtonPressed : bool = false
onready var flow = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	settings.connect("pressed", self, "_on_Settings_Pressed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currentController.refreshNotes($Label)

func _input(event):
	
	if event is InputEventScreenTouch and event.is_pressed():
		# If there is a button being pressed, nothing happens
		if isButtonPressed:
			isButtonPressed = false
			return
		
		var hasRhythm = currentController.hasRhythm(event)
		
		

func _on_Settings_Pressed():
	isButtonPressed = true
	print("settings")
