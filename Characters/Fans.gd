extends Node2D

const ROWS = 3
onready var r1 = get_node("%Row1")
onready var r2 = get_node("%Row2")
onready var r3 = get_node("%Row3")
onready var rows : Array = [r1, r2 ,r3]
onready var fanScene = preload("./Fan.tscn")
onready var tween = $Tween

onready var r1_positions = [Vector2(-293, -3), Vector2(-300, 3), Vector2(-307, -3)]
onready var r2_positions = [Vector2(-290, 97), Vector2(-285, 103), Vector2(-280, 97)]
onready var r3_positions = [Vector2(-293, 197), Vector2(-300, 203), Vector2(-307, 197)]

var fans

# Called when the node enters the scene tree for the first time.
func _ready():
	self.fans = 0
	self.refresh()
	self._start_tween()

func refresh():
	var n = GlobalVars.fansNumber - self.fans 	# new fans to add
	self.fans = GlobalVars.fansNumber			# new total number of fans
	
	if n < 0:
		for i in range(-1*n):
			self.removeFan()
		return
	
	for i in range(n):
		addFan()

func addFan():
	var children_numbers = [r1.get_child_count(), r2.get_child_count(), r3.get_child_count()]
	var row_selected = rows[argmin(children_numbers)]
	var new_fan = fanScene.instance()
	row_selected.add_child(new_fan)

func removeFan():
	var children_numbers = [r1.get_child_count(), r2.get_child_count(), r3.get_child_count()]
	var row_selected = rows[argmax(children_numbers)]
	var child = row_selected.get_child(0)
	child.queue_free()

func argmin(L):
	var min_ = INF
	var argmin = null
	for i in range(len(L)):
		var a = L[i]
		if a < min_:
			min_ = a
			argmin = i
	return argmin	

func argmax(L):
	var max_ = -1
	var argmax = null
	for i in range(len(L)):
		var a = L[i]
		if a > max_:
			max_ = a
			argmax = i
	return argmax	
	

func _start_tween():
	tween.interpolate_property(r1, "rect_position", r1_positions[0], r1_positions[1], 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)    
	tween.interpolate_property(r2, "rect_position", r2_positions[0], r2_positions[1], 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT) 
	tween.interpolate_property(r3, "rect_position", r3_positions[0], r3_positions[1], 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT) 
	tween.interpolate_property(r1, "rect_position", r1_positions[1], r1_positions[2], 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.4)    
	tween.interpolate_property(r2, "rect_position", r2_positions[1], r2_positions[2], 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.4) 
	tween.interpolate_property(r3, "rect_position", r3_positions[1], r3_positions[2], 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.4) 
	tween.start()
	
	yield(get_tree().create_timer(0.8), "timeout")
	r1_positions.invert()
	r2_positions.invert()
	r3_positions.invert()
	_start_tween()
