extends Node2D

onready var type = "Duck"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func remove():
	
	# If the Duck was defeated and the drum is locked, we unlocked the drum
	#  by adding it to the Inventory/Store
	if not ("Drum" in GlobalVars.Data["Inventory"]):
		var file = File.new()
		file.open("res://JSONs/Drum.json", File.READ)
		var content = file.get_as_text()
		file.close()
		var drum_data = JSON.parse(content).result
		GlobalVars.Data["Inventory"]["Drum"] = drum_data
		GlobalVars.save_data()
		
	self.queue_free()
