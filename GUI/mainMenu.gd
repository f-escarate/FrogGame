extends MarginContainer

onready var start = $VBoxContainer/Start
onready var settings = $VBoxContainer/Settings
onready var exit = $VBoxContainer/Exit


# Called when the node enters the scene tree for the first time.
func _ready():
	exit.connect("pressed", self, "_on_Exit_pressed")
	start.connect("pressed", self, "_on_Start_pressed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/main.tscn")
	pass # Replace with function body.

func _on_Exit_pressed():
	get_tree().quit()

