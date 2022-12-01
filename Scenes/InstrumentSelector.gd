extends HBoxContainer

onready var mic = $Microphone
onready var guitar = $Guitar
onready var drum = $Drum
onready var currentInstrument = Instruments.MIC

var player
var main

# Called when the node enters the scene tree for the first time.
func _ready():
	mic.connect("pressed", self, "toMic")
	guitar.connect("pressed", self, "toGuitar")
	drum.connect("pressed", self, "toDrum")
	
	show_unlocked_instruments()
	

func setParams(musicPlayer, aMain):
	self.player = musicPlayer
	self.main = aMain

func toMic():
	if currentInstrument != Instruments.MIC:
		self.main.mc.sing()
		var clicker = NormalClicker.new(self.player, self.main)
		self.main.setController(clicker)
		self.currentInstrument = Instruments.MIC

func toGuitar():
	if currentInstrument != Instruments.GUITAR:
		self.main.mc.playGuitar()
		var clicker = GuitarClicker.new(self.player, self.main)
		self.main.setController(clicker)
		self.currentInstrument = Instruments.GUITAR

func toDrum():
	if currentInstrument != Instruments.DRUM:
		self.main.mc.playDrum()
		var clicker = DrumClicker.new(self.player, self.main)
		self.main.setController(clicker)
		self.currentInstrument = Instruments.DRUM

func show_unlocked_instruments():
	# Showing the unlocked instruments only
	var instruments = [mic, guitar, drum]
	for i in range(len(instruments)):
		if Instruments.instruments_unlocked[i]:
			instruments[i].visible = true
