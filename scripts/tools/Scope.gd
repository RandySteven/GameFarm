class_name Scope extends Tool

var consume_grid_row: int = 1
var consume_grid_col: int = 1

func _ready():
	tool_name = "Scope"
	level = "steel"
	consume_grid_col = 1
	consume_grid_row = 1

func upgrade(next_level : String) -> bool:
	if not can_upgrade_to(next_level):
		return false
	
	# Determine grid size based on level
	match next_level:
		"steel":
			consume_grid_col = 1
			consume_grid_row = 1
		"copper":
			consume_grid_col = 3
			consume_grid_row = 3
		"silver":
			consume_grid_col = 6
			consume_grid_row = 6
		"gold":
			consume_grid_col = 9
			consume_grid_row = 9
		"diamond":
			consume_grid_col = 12
			consume_grid_row = 12
	
	# Call parent upgrade
	return super.upgrade(next_level)

func process(_delta : float) -> void:
	# TODO: Implement scope functionality
	# 1. Check next grid is farmland and not yet tilled
	# 2. If yes, upgrade next grid to tilled farmland
	pass

func enter() -> void:
	super()
	print("Scope equipped: ", get_display_name())

func exit() -> void:
	super()
	print("Scope unequipped")
