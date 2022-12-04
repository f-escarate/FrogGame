extends Node2D
class_name EnemyFactory

onready var gato = preload("res://Characters/Gato.tscn")
onready var pato = preload("res://Characters/Pato.tscn")
onready var createEnemy = ["createWitch", "createDuck"] # list of all enemies functions

func createRandomEnemy() -> int:
	var i : int = randi()%len(self.createEnemy)	# Selects a random index to choose a enemy creating function
	var funcRef = funcref(self, createEnemy[i])	# Creates a FuncRef
	funcRef.call_func()							# Calls the enemy creating function
	return i									# Returns the index (type of enemy created)

func createWitch():
	var witch = gato.instance()
	add_child(witch)

func createDuck():
	var duck = pato.instance()
	add_child(duck)
	
func removeEnemy(enemy):
	enemy.remove()
	remove_child(enemy)
