extends Node2D
class_name EnemyFactory

onready var enemy = preload("res://Characters/Enemy.tscn")
onready var createEnemy = ["createWitch", "createDuck"] # list of all enemies functions

func createRandomEnemy():
	var i : int = randi()%len(self.createEnemy)	# Selects a random index to choose a enemy creating function
	var funcRef = funcref(self, createEnemy[i])	# Creates a FuncRef
	funcRef.call_func()							# Calls the enemy creating function

func createWitch():
	var witch = enemy.instance()
	add_child(witch)

func createDuck():
	var duck = enemy.instance()
	add_child(duck)
	
func removeEnemy(enemy):
	enemy.queue_free()
	remove_child(enemy)
