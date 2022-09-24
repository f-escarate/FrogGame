extends ColorRect

var speed : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rect_position.y += speed * delta
	if rect_position.y >= 180 :
		queue_free()
	
func set_params(speed: float) -> void:
	self.speed = speed

