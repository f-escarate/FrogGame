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
	if GlobalVars.totalMoney >= price:
		set_quantity(quantity + 1)
		GlobalVars.totalMoney = GlobalVars.totalMoney - price
		Tienda_actual["Currency"] = GlobalVars.totalMoney
		var i =0
		while i < len(Tienda_actual["Inventory"]):
			if display_name == Tienda_actual["Inventory"][i].item:
				Tienda_actual["Inventory"][i].quantity = quantity
				Tienda_actual["Inventory"][i].price = price + floor(price/10+exp(quantity/10))
				set_price(Tienda_actual["Inventory"][i].price)
				break
			i = i +1
		save_tienda_actual()
	else:
		print(GlobalVars.totalMoney)

func save_tienda_actual():
	var file = File.new()
	file.open(GlobalVars.TIENDA_PATH, File.WRITE)
	file.store_string(JSON.print(Tienda_actual, " ", true))
	file.close()

func set_display_name(value):
	display_name = value
	name_label.text = value

func set_quantity(value):
	quantity = value
	quantity_label.text = "Level: " + str(value)

func set_price(value):
	price = value
	buy.text = "Price: " + str(value)

func set_icon(value):
	icon = value
	icon_label.texture = load(value)
