extends Sprite

onready var Mark = preload("res://Scenes/rhythmMark.tscn")
var size = texture.get_size().x
const mark_scale = 0.02

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func rhythmMark(speed : float, size: float):
	
	# Left mark
	var left_mark = Mark.instance()
	self.add_child(left_mark)
	left_mark.set_params(speed, mark_scale, self.global_position - Vector2(size*self.scale.x, 0))	
	
	# Right mark
	var right_mark = Mark.instance()
	self.add_child(right_mark)
	right_mark.set_params(-speed, mark_scale, self.global_position + Vector2(size*self.scale.x, 0))	
