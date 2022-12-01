extends Node2D

onready var label = $Label
onready var exit = $Button

# Called when the node enters the scene tree for the first time.
func _ready():
	exit.connect("button_down", self, "changeVisibility")

func changeVisibility():
	self.visible = not self.visible

func setText(description):
	label.text = description
