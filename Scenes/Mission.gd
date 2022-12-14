extends HBoxContainer

onready var label = $Label
onready var icon = $TextureRect
var missionText

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func setText(text):
	self.label.text = text
	
func setCompleted():
	icon.texture = load("res://images/GUI/tickIcon.jpg")

