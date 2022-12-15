extends Node2D
class_name EnemyFactory

onready var gato = preload("res://Characters/Gato.tscn")
onready var pato = preload("res://Characters/Pato.tscn")
onready var oso = preload("res://Characters/Oso.tscn")
onready var createEnemy = ["createWitch", "createDuck", "createBear"] # list of all enemies functions
onready var i = 0

func createRandomEnemy() -> int:
	var funcRef = funcref(self, createEnemy[i])	# Creates a FuncRef
	funcRef.call_func()							# Calls the enemy creating function
	var ret = self.i
	self.i = (self.i+1)%len(self.createEnemy)	# increasing the index
	return ret									# Returns the index (type of enemy created)

func createWitch():
	var witch = gato.instance()
	add_child(witch)

func createDuck():
	var duck = pato.instance()
	add_child(duck)

func createBear():
	var bear = oso.instance()
	add_child(bear)
	
func removeEnemy(enemy):
	enemy.remove()
	remove_child(enemy)
