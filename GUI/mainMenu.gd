extends MarginContainer

onready var buttons = $VBoxContainer/Buttons
onready var start = $VBoxContainer/Buttons/Start
onready var settings = $VBoxContainer/Buttons/Settings
onready var exit = $VBoxContainer/Buttons/Exit


# Called when the node enters the scene tree for the first time.
func _ready():
	# We set the container margin based on the window settings
	margin_right = ProjectSettings.get_setting("display/window/size/width")
	margin_bottom = ProjectSettings.get_setting("display/window/size/height")
	
	# Change font size
	var scaleFactor = margin_right/270
	var font = theme.get("default_font")
	font.size *= scaleFactor
	font.outline_size *= scaleFactor
	
	# Tittle-Buttons separation
	$VBoxContainer.add_constant_override("separation", scaleFactor*20)
		
	# Buttons connections
	start.connect("pressed", self, "_on_Start_pressed")
	exit.connect("pressed", self, "_on_Exit_pressed")


func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/main.tscn")

func _on_Exit_pressed():
	get_tree().quit()

