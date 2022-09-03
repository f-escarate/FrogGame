extends Area2D

var speed : float
onready var mark = $Mark

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += speed * transform.x * delta

func set_params(speed: float, scale: float, position: Vector2) -> void:
	self.speed = speed
	self.scale.x *= scale
	self.global_position = position


func _on_Area2D_area_entered(area):
	queue_free()
