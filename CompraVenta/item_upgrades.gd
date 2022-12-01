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
	return val + floor(val/10+exp(lvl/10))

func increase_fans(lvl):
	pass

func get_fans_info(lvl):
	return "tienes X fans"

func music_lessons(lvl):
	pass

func get_lessons_info(lvl):
	return "Vas en la X clase"
