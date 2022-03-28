extends Node
class_name PersonGenerator

var _surnames
var _male_given_names
var _female_given_names

func _init():
	var file = File.new()
	file.open("res://Scenarios/RandomizeTemplate/Data/surname.json", File.READ)
	_surnames = parse_json(file.get_as_text())
	
	file.open("res://Scenarios/RandomizeTemplate/Data/malegivenname.json", File.READ)
	_male_given_names = parse_json(file.get_as_text())
	
	file.open("res://Scenarios/RandomizeTemplate/Data/femalegivenname.json", File.READ)
	_female_given_names = parse_json(file.get_as_text())
	

func generate_person(scen, settings):
	var p = Person.new()
	
	var id = scen.persons.keys().max()
	if id == null:
		id = 1
	else:
		id = id + 1
		
	p._set_gender(randf() < settings["FemaleChance"])
	
	p.set_surname(Util.random_from(_surnames))
	p.set_given_name(Util.random_from(_female_given_names if p.gender else _male_given_names))
	
	p._set_available_years(settings["ScenarioYear"], rand_range(15, 30), rand_range(30, 80))

	p.set_command(40 + rand_range(0, 30) + rand_range(0, 30))
	p.set_strength(40 + rand_range(0, 30) + rand_range(0, 30))
	p.set_intelligence(40 + rand_range(0, 30) + rand_range(0, 30))
	p.set_politics(40 + rand_range(0, 30) + rand_range(0, 30))
	p.set_glamour(40 + rand_range(0, 30) + rand_range(0, 30))
	
	p._reset_strain()
	p.set_ideal(rand_range(0, 149))
	p.set_ambition(rand_range(0, 50) + rand_range(0, 50))
	p.set_morality(rand_range(0, 50) + rand_range(0, 50))
	p.set_braveness(rand_range(0, 50) + rand_range(0, 50))
	p.set_calmness(rand_range(0, 50) + rand_range(0, 50))
	
	for skill in scen.skills:
		var ability = p.command * skill.generator["Command"] + p.strength * skill.generator["Strength"] + p.intelligence * skill.generator["Intelligence"] + p.politics * skill.generator["Politics"] + p.glamour * skill.generator["Glamour"]
		if skill.generator["AbilityThreshold"] > 0:
			if randf() < (ability - skill.generator["AbilityThreshold"]) * 0.01:
				p.set_skills(skill.id)
				var level = 1
				while randf() < (ability - skill.generator["AbilityThreshold"] - skill.generator["LevelThreshold"] * level) * 0.01:
					p.increment_skill_level(skill.id)
					level += 1
		elif skill.generator["AbilityThreshold"] < 0:
			if randf() < (-skill.generator["AbilityThreshold"] - ability) * 0.01:
				p.set_skills(skill.id)
				var level = 1
				while randf() < (-skill.generator["AbilityThreshold"] - ability - skill.generator["LevelThreshold"] * level) * 0.01:
					p.increment_skill_level(skill.id)
					level += 1
