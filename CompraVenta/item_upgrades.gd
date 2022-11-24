extends Node
class_name Item_Upgrades

const MIC = 0
const GUITAR = 1
const DRUM = 2

func upgrade_mic():
	var new_value = 5			# Esto se debe hacer usando una formula
	GlobalVars.upgrade_instrument(MIC, new_value)

func upgrade_guitar():
	if GlobalVars.instruments_unlocked[GUITAR]:
		var new_value = 5			# Esto se debe hacer usando una formula
		GlobalVars.upgrade_instrument(GUITAR, new_value)
	else:
		GlobalVars.unlock_instrument(GUITAR)

func upgrade_drum():
	if GlobalVars.instruments_unlocked[DRUM]:
		var new_value = 5			# Esto se debe hacer usando una formula
		GlobalVars.upgrade_instrument(DRUM, new_value)
	else:
		GlobalVars.unlock_instrument(DRUM)

func no_fun():
	print("taka")
	pass
