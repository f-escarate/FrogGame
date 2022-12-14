extends HBoxContainer

onready var label = $Label
onready var claimButton = $Claim
var missionText
var reward
var index # Is the index according to the JSON file
var removeFunRef : FuncRef

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func setFields(text, money, removeFun, index):
	self.label.text = text
	self.claimButton.text =  "+$%d " % [money]
	self.reward = money
	self.index = index
	self.removeFunRef = removeFun
	
func setCompleted():
	claimButton.modulate = Color(1,1,1)
	claimButton.connect("button_up", self, "claimReward")

func claimReward():
	GlobalVars.totalMoney = GlobalVars.totalMoney + self.reward
	GlobalVars.refreshMoneyGUI.call_func()
	self.removeFunRef.call_func(self.index)
	GlobalVars.save_data()

