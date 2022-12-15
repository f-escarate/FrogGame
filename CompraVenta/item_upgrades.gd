extends Node
class_name Item_Upgrades

func upgrade_mic(lvl):
	upgrade_instrument(Instruments.MIC, lvl)

func upgrade_guitar(lvl):
	upgrade_instrument(Instruments.GUITAR, lvl)

func upgrade_drum(lvl):
	upgrade_instrument(Instruments.DRUM, lvl)

func upgrade_instrument(instrument, lvl):
	if Instruments.instruments_unlocked[instrument]:
		var current_val = Instruments.instruments_click_progress[instrument]
		var new_value = instrument_formula(current_val, lvl)
		Instruments.upgrade_instrument(instrument, new_value)
		return
	Instruments.unlock_instrument(instrument)

func get_mic_info(lvl):
	return get_instrument_info(Instruments.MIC, lvl)

func get_guitar_info(lvl):
	return get_instrument_info(Instruments.GUITAR, lvl)

func get_drum_info(lvl):
	return get_instrument_info(Instruments.DRUM, lvl)

func get_instrument_info(instrument, lvl):
	var current_val = Instruments.instruments_click_progress[instrument]
	var next_val = instrument_formula(current_val, lvl)
	var info = "Current progress: %s\n Next level progress: %s" % [current_val, next_val]
	return info

func instrument_formula(val, lvl):
	if lvl/10 < 1:
		return val + 1
	else:
		return val + floor(lvl/10) + 1 

func increase_fans(_lvl):
	var n = 1		# Hay que hacer una fórmula
	GlobalVars.addFans(n)

func get_fans_info(_lvl):
	return "You have %s fans. Each ad attracts one more." % [GlobalVars.fansNumber]

func music_lessons(lvl):
	GlobalVars.mejoraMamalona = lvl/10
	GlobalVars.save_data()

func get_lessons_info(lvl):
	return "You have done %s lessons" % [lvl]
