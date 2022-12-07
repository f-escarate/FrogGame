extends Control

const MAX_CHILD_COUNT = 5
onready var r1 = get_node("%Row1")
onready var r2 = get_node("%Row2")
onready var r3 = get_node("%Row3")
onready var r4 = get_node("%Row4")
onready var rows : Array = [r1, r2 ,r3, r4]
onready var fanScene = preload("./Fan.tscn")
onready var tween = $Tween
onready var label = $Label

onready var r1_positions = [Vector2(-7, -3), Vector2(0, 3), Vector2(7, -3)]
onready var r2_positions = [Vector2(-3, 47), Vector2(-10, 53), Vector2(-17, 47)]
onready var r3_positions = [Vector2(-7, 107), Vector2(0, 113), Vector2(7, 107)]
onready var r4_positions = [Vector2(-3, 177), Vector2(-10, 183), Vector2(-17, 177)]

var fans

# Called when the node enters the scene tree for the first time.
func _ready():
	self.fans = 0
	self.refresh()
	self._start_tween()

func refresh():
	var n = GlobalVars.fansNumber - self.fans 	# new fans to add
	self.fans = GlobalVars.fansNumber			# new total number of fans
	self.label.text = "Fans: %s" % [self.fans]
	
	if n < 0 and self.fans<len(rows)*MAX_CHILD_COUNT:
		self.removeFans(-1*n)
		return
	addFans(n)


func addFans(n):
	for row in rows:
		var child_count = row.get_child_count()
		while child_count < MAX_CHILD_COUNT and n > 0:
			var new_fan = fanScene.instance()
			row.add_child(new_fan)
			child_count = row.get_child_count()
			n -= 1
	

func removeFans(n):
	for i in rows.size():
		var row = rows[-i-1]
		var child_count = row.get_child_count()
		while child_count > 0 and n > 0:
			var child = row.get_child(0)
			child.queue_free()
			child_count = row.get_child_count()
			n -= 1
	

func _start_tween():
	tween.interpolate_property($posR1, "position", r1_positions[0], r1_positions[1], 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)    
	tween.interpolate_property($posR2, "position", r2_positions[0], r2_positions[1], 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT) 
	tween.interpolate_property($posR3, "position", r3_positions[0], r3_positions[1], 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT) 
	tween.interpolate_property($posR4, "position", r4_positions[0], r4_positions[1], 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT) 
	
	tween.interpolate_property($posR1, "position", r1_positions[1], r1_positions[2], 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.4)    
	tween.interpolate_property($posR2, "position", r2_positions[1], r2_positions[2], 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.4) 
	tween.interpolate_property($posR3, "position", r3_positions[1], r3_positions[2], 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.4) 
	tween.interpolate_property($posR4, "position", r4_positions[1], r4_positions[2], 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.4) 
	tween.start()
	
	yield(get_tree().create_timer(0.8), "timeout")
	r1_positions.invert()
	r2_positions.invert()
	r3_positions.invert()
	r4_positions.invert()
	_start_tween()
