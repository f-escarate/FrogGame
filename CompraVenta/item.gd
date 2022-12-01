extends HBoxContainer

onready var name_label = $Name
onready var quantity_label = $Quantity
onready var buy = $Buy
onready var icon = $Icon
onready var floatingText = preload("res://effects/FloatingText.tscn")

var display_name = "" setget set_display_name
var icon_path = "" setget set_icon_path
var quantity = 0 setget set_quantity
var price = 0 setget set_price
var fun setget set_fun
var description setget set_description

var fun_ref : FuncRef
var Tienda_actual =  GlobalVars.Data
var show_description_ref: FuncRef

func _ready():
	buy.connect("button_up",self,"_buy")
	icon.connect("gui_input", self, "_showInfo")
	name_label.connect("gui_input", self, "_showInfo")
	quantity_label.connect("gui_input", self, "_showInfo")

func _buy():
	if GlobalVars.totalMoney >= price:
		set_quantity(quantity + 1)
		GlobalVars.totalMoney = GlobalVars.totalMoney - price
		Tienda_actual["Currency"] = GlobalVars.totalMoney
		GlobalVars.refreshMoneyGUI.call_func()	# refreshing the GUI of the Main Scene
		
		# Searching the element in the inventory
		for element in Tienda_actual["Inventory"]:
			if display_name == element.item:
				element.quantity = quantity
				element.price = price + floor(price/10+exp(quantity/10))
				self.set_price(element.price)
				self.call_upgrade_function(element.fun)
				break
		GlobalVars.save_data()
	else:
		noMoneyMsg()

func set_display_name(value):
	display_name = value
	name_label.text = value

func set_quantity(value):
	quantity = value
	quantity_label.text = "Level: " + str(value)

func set_price(value):
	price = value
	buy.text = "Price: " + str(value)

func set_icon_path(value):
	icon_path = value
	icon.texture = load(value)

func set_fun(value):
	fun = value

func set_description(value):
	description = value
	
func call_upgrade_function(fun_name):
	var fun_ref = funcref(GlobalVars.item_upgrades, str(fun_name))
	fun_ref.call_func()
	
func noMoneyMsg():
	var ftext = floatingText.instance()
	ftext.z_index = 2
	ftext.setColor(Color("#ed5f47"))
	var middle = self.rect_size.x/2 + self.rect_position.x
	ftext.setPosition(Vector2(middle,0))
	ftext.setText("not enough money")
	self.add_child(ftext)

func _showInfo(event):
	if event is InputEventScreenTouch and event.is_pressed():
		show_description_ref.call_func(self.description)
