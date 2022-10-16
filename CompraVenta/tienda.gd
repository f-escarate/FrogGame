extends MarginContainer

onready var items = $Container/Items

var item_scene = preload("res://CompraVenta/Item.tscn")

var Items_Tienda = {} setget set_Tienda

# Called when the node enters the scene tree for the first time.
func _ready():
	load_tienda()

func load_tienda():
	self.Items_Tienda = GlobalVars.Items_Tiendita

func set_Tienda(value):
	Items_Tienda = value
	_update_tienda()

func _update_tienda():
	for child in items.get_children():
		items.remove_child(child)
		child.queue_free()
	for item in Items_Tienda["Inventory"]:
		var ui_item = item_scene.instance()
		items.add_child(ui_item)
		ui_item.display_name = item.item
		ui_item.quantity = item.quantity
		ui_item.price = item.price
