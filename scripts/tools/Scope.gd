class_name Scope extends Tool

static var level_scope : String = "steel"
static var consume_grid_row = 1
static var consume_grid_col = 1

func upgrade(next_level : String) -> bool:
	var possible_upgrade = false
	if next_level == level_scope:
		return possible_upgrade
	
	if level_scope == "steel" && next_level == "copper":
		consume_grid_col = 3
		consume_grid_row = 3
		possible_upgrade = true
	if level_scope == "copper" && next_level == "silver":
		consume_grid_col = 6
		consume_grid_row = 6
		possible_upgrade = true
	if level_scope == "silver" && next_level == "gold":
		consume_grid_col = 9
		consume_grid_row = 9
		possible_upgrade = true
	if level_scope == "gold" && next_level == "diamond":
		consume_grid_col = 12
		consume_grid_row = 12
		possible_upgrade = true

	level_scope = next_level
	return possible_upgrade

func process(delta : float) -> Tool:
	#1. check next grid is lahan and belum di cangkul
	#2. kalau iya
	#2.1. upgrade next grid jadi lahan yang udah dicangkul
	
	return null
