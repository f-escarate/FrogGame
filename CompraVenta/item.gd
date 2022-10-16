extends HBoxContainer

onready var name_label = $Name
onready var quantity_label = $Quantity
onready var buy = $Buy
onready var icon_label = $Icon

var display_name = "" setget set_display_name
var icon = "" setget set_icon
var quantity = 0 setget set_quantity
var price = 0 setget set_price
var Tienda_actual =  GlobalVars.Items_Tiendita

func _ready():
	buy.connect("button_up",self,"_buy")
	

func _buy():
	set_quantity(quantity + 1)
	
	var i =0
	while i < len(Tienda_actual["Inventory"]):
		if display_name == Tienda_actual["Inventory"][i].item:
			Tienda_actual["Inventory"][i].quantity = quantity
			break
		i = i +1
	save_tienda_actual()

func save_tienda_actual():
	var file = File.new()
	file.open("res://CompraVenta/Tienda.json",File.WRITE)
	file.store_string(JSON.print(Tienda_actual," ",true))
	file.close()

func set_display_name(value):
	display_name = value
	name_label.text = value

func set_quantity(value):
	quantity = value
	quantity_label.text = "Nivel: " + str(value)

func set_price(value):
	price = value
	buy.text = "Presio: " + str(value)

func set_icon(value):
	icon = value