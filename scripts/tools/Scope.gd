class_name Scope extends Tool

static var level_scope : String = "bronze"
static var consume_grid_row = 1
static var consume_grid_col = 1

func upgrade(next_level : String) -> bool:
	if next_level == level_scope:
		return false
	if level_scope == "bronze" && next_level == "silver":
		level_scope = next_level
		consume_grid_col = 3
		consume_grid_row = 3
		return true
	if level_scope == "silver" && next_level == "gold":
		level_scope = next_level
		consume_grid_col = 6
		consume_grid_row = 6
		return true
	if level_scope == "gold" && next_level == "diamond":
		level_scope = next_level
		consume_grid_col = 9
		consume_grid_row = 9
		return true
	return false
	
