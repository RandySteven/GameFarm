class_name IdleState extends State

@onready var walk_state : State = $"../Walk"
@onready var scope_state : State = $"../Scope"
@onready var water_state : State = $"../Water"

func enter() -> void:
	player.update_animation("idle")

func process(delta : float) -> State:
	if player.direction != Vector2.ZERO:
		return walk_state
	player.velocity = Vector2.ZERO
	return null

func handle_input(event : InputEvent) -> State :
	
	if event.is_action_pressed("action"):
		return _current_state_action()
	
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1, KEY_KP_1:
				player.tool_bag.equip_tool(0)
				print("Switched to tool: ", player.tool_bag.get_all_tool_names()[0] if player.tool_bag.tools.size() > 0 else "none")
			KEY_2, KEY_KP_2:
				if player.tool_bag.tools.size() > 1:
					player.tool_bag.equip_tool(1)
					print("Switched to tool: ", player.tool_bag.get_all_tool_names()[1])
			KEY_TAB:
				player.tool_bag.equip_next_tool()
	
	return null	

func _current_state_action() -> State:
	if player.tool_bag.get_current_tool().tool_name=="Scope":
		return scope_state
	if player.tool_bag.get_current_tool().tool_name=="Water Can":
		return water_state
	return null
