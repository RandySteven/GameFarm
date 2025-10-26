class_name IdleState extends State

@onready var walk_state : State = $"../Walk"
@onready var scope_state : State = $"../Scope"

func enter() -> void:
	player.update_animation("idle")

func process(delta : float) -> State:
	if player.direction != Vector2.ZERO:
		return walk_state
	player.velocity = Vector2.ZERO
	return null

func handle_input(event : InputEvent) -> State :
	
	if event.is_action_pressed("scope"):
		return scope_state
	
	# Tool switching with number keys
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
				# Cycle through tools with Tab
				player.tool_bag.equip_next_tool()
	
	return null	
