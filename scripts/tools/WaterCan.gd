class_name WaterCan extends Tool

var water_capacity : int = 30
var level_water_can : String = "steel"

func enter() -> void:
	pass

func upgrade(next_level : String) -> bool:
	var possible_upgrade = false
	if next_level == level_water_can:
		return possible_upgrade

	if level_water_can == "steel" && next_level == "copper":
		water_capacity = 60
		level_water_can = next_level
		possible_upgrade = true
	if level_water_can == "copper" && next_level == "silver":
		level_water_can = next_level
		water_capacity = 90
		possible_upgrade = true
	if level_water_can == "silver" && next_level == "gold":
		level_water_can = next_level
		water_capacity = 120
		possible_upgrade = true
	if level_water_can == "gold" && next_level == "diamond":
		level_water_can = next_level
		water_capacity = 180
		possible_upgrade = true

	level_water_can = next_level
	return possible_upgrade

	
func process(_delta : float) -> WaterCan:
	water_capacity -= 1
	return null
