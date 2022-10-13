extends MarginContainer

onready var container = $VBoxContainer
onready var buttons = $VBoxContainer/Buttons
onready var start = $VBoxContainer/Buttons/Start
onready var settings = $VBoxContainer/Buttons/Settings
onready var exit = $VBoxContainer/Buttons/Exit


# Called when the node enters the scene tree for the first time.
func _ready():
	# We set the container margin based on the window settings	
	container.anchor_left = GlobalVars.width/2
	container.anchor_top = GlobalVars.height/2
	
	# Buttons connections
	start.connect("pressed", self, "_on_Start_pressed")
	settings.connect("pressed", self, "_on_Settings_pressed")
	exit.connect("pressed", self, "_on_Exit_pressed")


func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/mainScene.tscn")

func _on_Settings_pressed():
	get_tree().change_scene("res://Scenes/mainScene.tscn")

func _on_Exit_pressed():
	get_tree().quit()

