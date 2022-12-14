extends Node

const MIC = 0
const GUITAR = 1
const DRUM = 2

# Instruments vars/consts
const DEFAULT_INSTRUMENT_INFO_PATH = "res://JSONs/instruments.json"
const INSTRUMENT_INFO_PATH = "user://instruments.json" 			# Path for Android saves

var instruments_unlocked : Array
var instruments_click_progress : Array
var refreshInstruments : FuncRef # Function reference used to refresh the unlocked instruments

func _ready():
	load_instruments_data()

func read_instrument_file():
	var file = File.new()
	if file.file_exists(INSTRUMENT_INFO_PATH):
		file.open(INSTRUMENT_INFO_PATH, File.READ)
	else:
		file.open(DEFAULT_INSTRUMENT_INFO_PATH, File.READ)
	var content = file.get_as_text()
	file.close()
	var data = JSON.parse(content).result
	return data

func write_instrument_data(content):
	var file = File.new()
	file.open(Instruments.INSTRUMENT_INFO_PATH, File.WRITE)
	file.store_string(JSON.print(content, " ", true))
	file.close()

func load_instruments_data():
	var data = read_instrument_file()
	self.instruments_unlocked = data["unlocked"]
	self.instruments_click_progress = data["click_progress"]

func unlock_instrument(index : int):
	# Reading
	var content = read_instrument_file()
	# Unlocking instrument
	content["unlocked"][index] = true
	self.instruments_unlocked = content["unlocked"]
	# Writing
	write_instrument_data(content)
	# Refreshing GUI
	self.refreshInstruments.call_func()

func upgrade_instrument(index : int, factor : int):
	# Reading
	var content = read_instrument_file()
	# Upgrading instrument
	content["click_progress"][index] = factor
	# Writing
	write_instrument_data(content)
	# Reloading data
	self.instruments_click_progress = content["click_progress"]
