extends HBoxContainer
enum instrument {MIC, GUITAR}

onready var mic = $Microphone
onready var guitar = $Guitar
onready var currentInstrument = instrument.MIC

var player
var main

# Called when the node enters the scene tree for the first time.
func _ready():
	mic.connect("pressed", self, "toMic")
	guitar.connect("pressed", self, "toGuitar")

func setParams(musicPlayer, aMain):
	self.player = musicPlayer
	self.main = aMain

func toMic():
	if currentInstrument != instrument.MIC:
		self.main.mc.sing()
		var clicker = NormalClicker.new(self.player, self.main)
		self.main.setController(clicker)
		self.currentInstrument = instrument.MIC

func toGuitar():
	if currentInstrument != instrument.GUITAR:
		self.main.mc.playGuitar()
		var clicker = GuitarClicker.new(self.player, self.main)
		self.main.setController(clicker)
		self.currentInstrument = instrument.GUITAR
