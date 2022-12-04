extends MarginContainer

onready var items = $ColorRect/ScrollContainer/Items
onready var description = $Description

var item_scene = preload("res://CompraVenta/Item.tscn")
var Items_Tienda = {} setget set_Tienda

# Called when the node enters the scene tree for the first time.
func _ready():
	load_tienda()

func load_tienda():
	self.Items_Tienda = GlobalVars.Data

func set_Tienda(value):
	Items_Tienda = value
	update_store()

func update_store():
	for child in items.get_children():
		items.remove_child(child)
		child.queue_free()
	for item_name in Items_Tienda["Inventory"]:
		var item = Items_Tienda["Inventory"][item_name]
		var ui_item = item_scene.instance()
		items.add_child(ui_item)
		var show_fun_ref = funcref(self, "_showDescription")
		ui_item.setFields(item_name, item.lvl, item.price, item.icon_path,
						 item.description, item.info_fun, show_fun_ref)

func _showDescription(text, stats):
	description.setText(text, stats)
	description.changeVisibility()
