extends ColorRect

var speed : float
var depth
var index : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rect_position.y += speed * delta
	if  self.depth - rect_position.y < -speed*GlobalVars.GOOD_HIT:
		queue_free()
	if  self.depth - rect_position.y < speed*GlobalVars.GOOD_HIT:
		self.visible = false
	
func set_params(speed: float, depth, markIndex: int) -> void:
	self.speed = speed
	self.depth = depth
	self.index = markIndex

