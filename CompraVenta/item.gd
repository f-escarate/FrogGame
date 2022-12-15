extends HBoxContainer

onready var name_label = $Name
onready var lvl_label = $Level
onready var buy = $Buy
onready var icon = $Icon
onready var floatingText = preload("res://effects/FloatingText.tscn")

var display_name = "" setget set_display_name
var description = "" setget set_description
var icon_path = "" setget set_icon_path
var price = 0 setget set_price
var lvl = 0 setget set_lvl
var fun setget set_fun
var info_fun setget set_info_fun

var fun_ref : FuncRef
var info_fun_ref: FuncRef
var Tienda_actual =  GlobalVars.Data
var show_description_ref: FuncRef
var isDragging : bool = false

func _ready():
	buy.connect("button_up",self,"_buy")
	icon.connect("gui_input", self, "_showInfo")
	name_label.connect("gui_input", self, "_showInfo")
	lvl_label.connect("gui_input", self, "_showInfo")

func _buy():
	if GlobalVars.totalMoney >= price:
		set_lvl(lvl + 1)
		GlobalVars.totalMoney = GlobalVars.totalMoney - price
		GlobalVars.refreshMoneyGUI.call_func()	# refreshing the GUI of the Main Scene
		
		# Searching the element in the inventory
		var element = Tienda_actual["Inventory"][display_name]
		element.lvl = lvl
		element.price = price + floor(price/6+exp(lvl/6))
		self.set_price(element.price)
		self.call_upgrade_function(element.fun)
			
		GlobalVars.refreshMissionsRef.call_func()
		GlobalVars.save_data()
	else:
		noMoneyMsg()

func set_display_name(value):
	display_name = value
	name_label.text = value

func set_lvl(value):
	lvl = value
	lvl_label.text = "Level: " + str(value)

func set_price(value):
	price = value
	buy.text = "Price: " + str(value)

func set_icon_path(value):
	icon_path = value
	icon.texture = load(value)

func set_fun(value):
	fun = value
	
func set_info_fun(value):
	info_fun = value
	
func set_description(value):
	description = value
	
func call_upgrade_function(fun_name):
	var fun_ref = funcref(GlobalVars.item_upgrades, str(fun_name))
	fun_ref.call_func(lvl)
	
func noMoneyMsg():
	var ftext = floatingText.instance()
	ftext.z_index = 2
	ftext.setColor(Color("#ed5f47"))
	var middle = Vector2(self.rect_size.x/2 + self.rect_position.x, self.rect_size.y/2)
	ftext.setPosition(middle)
	ftext.setText("not enough money")
	self.add_child(ftext)

func _showInfo(event):
	if event is InputEventScreenTouch and not event.is_pressed() and not self.isDragging:
		var get_info_fun_ref = funcref(GlobalVars.item_upgrades, str(self.info_fun))
		var stats_text = get_info_fun_ref.call_func(lvl)
		show_description_ref.call_func(self.description, stats_text)
		
	if event.is_pressed() and self.isDragging:
		self.isDragging = false
		
	if event is InputEventScreenDrag:
		self.isDragging = true
		
func setFields(name, lvl, price, icon_path, description, get_info_fun_ref, show_fun_ref):
	self.display_name = name
	self.lvl = lvl
	self.price = price
	self.icon_path = icon_path
	self.description = description
	self.info_fun = get_info_fun_ref
	self.show_description_ref = show_fun_ref
