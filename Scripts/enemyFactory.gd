extends Node2D
class_name EnemyFactory

onready var enemy = preload("res://Characters/Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func createWitch():
	var witch = enemy.instance()
	add_child(witch)
	
