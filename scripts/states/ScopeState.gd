class_name ScopeState extends State

@onready var idle_state : State = $"../Idle"

func process(_delta : float) -> State:
	if player.current_tool == null || player.current_tool != Scope:
		return idle_state
	
	player.current_tool.process(_delta)
	
	return null
