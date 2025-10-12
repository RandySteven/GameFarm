class_name Scope extends Tool

static var level_scope : String = "steel"
static var consume_grid_row = 1
static var consume_grid_col = 1

func upgrade(next_level : String) -> bool:
	if next_level == level_scope:
		return false
	if level_scope == "steel" && next_level == "copper":
		consume_grid_col = 3
		consume_grid_row = 3
	if level_scope == "copper" && next_level == "silver":
		consume_grid_col = 6
		consume_grid_row = 6
	if level_scope == "silver" && next_level == "gold":
		consume_grid_col = 9
		consume_grid_row = 9
	if level_scope == "gold" && next_level == "diamond":
		consume_grid_col = 12
		consume_grid_row = 12
	level_scope = next_level
	return true
	
