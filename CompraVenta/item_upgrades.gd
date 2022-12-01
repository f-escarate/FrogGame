extends Node
class_name Item_Upgrades

func upgrade_mic():
	upgrade_instrument(Instruments.MIC)

func upgrade_guitar():
	upgrade_instrument(Instruments.GUITAR)

func upgrade_drum():
	upgrade_instrument(Instruments.DRUM)

func upgrade_instrument(instrument):
	if GlobalVars.instruments_unlocked[instrument]:
		var new_value = 5			# Esto se debe hacer usando una formula
		GlobalVars.upgrade_instrument(instrument, new_value)
		return
	GlobalVars.unlock_instrument(instrument)

func no_fun():
	pass
