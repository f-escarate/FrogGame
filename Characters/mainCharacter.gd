extends Node2D

onready var anim_player = $body/AnimationPlayer
onready var anim_tree = $body/AnimationTree
onready var playback = anim_tree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	sing()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("test"):
		print("test")

func playGuitar():
	anim_player.play("playingGuitar")

func sing():
	anim_player.play("singing")
