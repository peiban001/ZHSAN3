extends Node
class_name ScenarioGenerator

func generate(settings):	
	var person_generator = PersonGenerator.new()
	
	var scenario = Scenario.new()
	
	for c in range(0, settings["OfficerCount"]):
		var person = person_generator.generate_person(scenario, settings)
