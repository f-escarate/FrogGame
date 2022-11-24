extends Position2D

onready var label = $Label
onready var tween = $Tween
var text_color : Color = Color(0.423529, 0.823529, 0.470588)
var text

# Called when the node enters the scene tree for the first time.
func _ready():
	label.modulate = self.text_color
	label.set_text(self.text)
	
	tween.interpolate_property(self, "scale", scale, Vector2(1.5,1.5), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, "scale", Vector2(1.5,1.5), Vector2(0.1,0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
	tween.start()

func setText(text):
	self.text = text
	
func setPosition(pos):
	self.position = pos

func setColor(color):
	self.text_color = color

func _on_Tween_tween_all_completed():
	self.queue_free()
