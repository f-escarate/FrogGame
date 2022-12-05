extends Node2D

const ROWS = 3
onready var r1 = get_node("%Row1")
onready var r2 = get_node("%Row2")
onready var r3 = get_node("%Row3")
onready var rows : Array = [r1, r2 ,r3]
onready var fanScene = preload("./Fan.tscn")
var fans

# Called when the node enters the scene tree for the first time.
func _ready():
	self.fans = 0
	self.refresh()

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
