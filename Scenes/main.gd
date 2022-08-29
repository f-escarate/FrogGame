extends Node2D

onready var settings = $Settings
onready var currentController = Clicker.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	settings.connect("pressed", self, "_on_Settings_Pressed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		currentController.action(event)

func _on_Settings_Pressed():
	print("settings")
