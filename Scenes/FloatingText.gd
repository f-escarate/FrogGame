extends Position2D

onready var label = $Label
onready var tween = $Tween
onready var text
# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_text(self.text)
	self.position = Vector2(0, -GlobalVars.height/4)
	tween.interpolate_property(self, "scale", scale, Vector2(1.5,1.5), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, "scale", Vector2(1.5,1.5), Vector2(0.1,0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
	tween.start()

func setText(text):
	self.text = text

func _on_Tween_tween_all_completed():
	self.queue_free()
