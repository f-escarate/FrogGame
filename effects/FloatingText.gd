extends Position2D

onready var label = $Label
onready var tween = $Tween
var text_color : Color = Color(0.423529, 0.823529, 0.470588)
var text
var t_appear
var t_stay
var t_disappear

# Called when the node enters the scene tree for the first time.
func _ready():
	label.modulate = self.text_color
	label.set_text(self.text)
	
	if self.t_appear == null:
		self.t_appear = 0.2
		self.t_stay = 0.3
		self.t_disappear = 0.7
	
	tween.interpolate_property(self, "scale", scale, Vector2(1.5,1.5), self.t_appear, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, "scale", Vector2(1.5,1.5), Vector2(0.1,0.1), self.t_disappear, Tween.TRANS_LINEAR, Tween.EASE_OUT, self.t_stay)
	tween.start()

func setText(text):
	self.text = text
	
func setPosition(pos):
	self.position = pos

func setColor(color):
	self.text_color = color

func setTimes(t0, t1, t2):
	self.t_appear = t0
	self.t_stay = t1
	self.t_disappear = t2

func _on_Tween_tween_all_completed():
	self.queue_free()
