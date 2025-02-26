extends Panel

var _scenario

func _on_Cancel_pressed():
	hide()


func init(scen):
	_scenario = scen
	$G/FactionCount.max_value = int(_scenario['Architectures'].size() * 0.9)
	show()


func _on_OfficerCount_value_changed(value):
	$G/OfficerCountText.text = str(value)


func _on_FactionCount_value_changed(value):
	$G/FactionCountText.text = str(value)
	$G/OfficerCount.min_value = max(100, value * $G/FactionOfficerCount.value)


func _on_FactionOfficerCount_value_changed(value):
	$G/FactionOfficerCountText.text = str(value)
	$G/FactionCount.max_value = int(min(_scenario['Architectures'].size() * 0.9, 3000 / value))
	$G/OfficerCount.min_value = value * $G/FactionCount.value



func _on_FemaleChance_value_changed(value):
	$G/FemaleChanceText.text = str(value)


func _on_Confirm_pressed():
	var settings = {}
	settings["ScenarioYear"] = _scenario["GameData"]["Year"]
	settings["FemaleChance"] = $G/FemaleChance.value
	settings["OfficerCount"] = $G/OfficerCount.value
	settings["FactionCount"] = $G/FactionCount.value
	settings["FactionOfficerCount"] = $G/FactionOfficerCount.value
	
	var scen = ScenarioGenerator.new().generate(settings)
