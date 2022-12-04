extends Node2D

const ROWS = 3
onready var rows : Array = [$Rows/Row1, $Rows/Row2, $Rows/Row3]


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(3):
		addFan()


func addFan():
	var row_selected = rows[randi()%3]
	var new_fan = Node2D.new()
	row_selected.add_child(row_selected)
