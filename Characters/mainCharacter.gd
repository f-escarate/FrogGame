extends Node2D

onready var anim_player = $body/AnimationPlayer
onready var anim_tree = $body/AnimationTree
onready var playback = anim_tree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	sing()

func sing():
	anim_player.play("singing")

func playGuitar():
	anim_player.play("playingGuitar")

func playDrum():
	anim_player.play("singing")
