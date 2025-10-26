class_name WaterCan extends Tool

var water_capacity : int = 30
var current_water : int = 30

func _ready():
	tool_name = "Water Can"
	level = "steel"
	water_capacity = 30
	current_water = 30

func enter() -> void:
	super()
	print("Water Can equipped: ", get_display_name(), " (", current_water, "/", water_capacity, " water)")

func upgrade(next_level : String) -> bool:
	if not can_upgrade_to(next_level):
		return false
	
	# Determine water capacity based on level
	match next_level:
		"steel":
			water_capacity = 30
		"copper":
			water_capacity = 60
		"silver":
			water_capacity = 90
		"gold":
			water_capacity = 120
		"diamond":
			water_capacity = 180
	
	# Refill when upgraded
	current_water = water_capacity
	
	# Call parent upgrade
	return super.upgrade(next_level)

func process(_delta : float) -> void:
	# Water drains over time or when used
	pass

# Refill the water can
func refill() -> void:
	current_water = water_capacity
	print("Water Can refilled: ", current_water, "/", water_capacity)

# Check if water can has water
func has_water() -> bool:
	return current_water > 0

# Get water percentage
func get_water_percentage() -> float:
	return float(current_water) / float(water_capacity)

func exit() -> void:
	super()
	print("Water Can unequipped")
