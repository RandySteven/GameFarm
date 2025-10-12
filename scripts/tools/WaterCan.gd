class_name WaterCan extends Tool

var water_capacity : int = 60
var level_water_can : String = "bronze"

func enter() -> void:
	pass

func upgrade(next_level : String) -> bool:
	if next_level == level_water_can:
		return false
	if level_water_can == "bronze" && next_level == "silver":
		level_water_can = next_level
		water_capacity = 90
		return true
	if level_water_can == "silver" && next_level == "gold":
		level_water_can = next_level
		water_capacity = 120
		return true
	if level_water_can == "gold" && next_level == "diamond":
		level_water_can = next_level
		water_capacity = 180
		return true
	return false

	
func process(_delta : float) -> WaterCan:
	water_capacity -= 1
	return null
