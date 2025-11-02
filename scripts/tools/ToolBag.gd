class_name ToolBag extends Node

var tools : Array[Tool] = []
var current_tool : Tool
var current_tool_index : int = -1

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	
func initialize(player : CharacterBody2D):
	tools = []
	
	for child in get_children():
		if child is Tool:
			tools.append(child)
			print("tool "+child.name)
	
	if tools.size() > 0:
		Tool.player = player
		
		equip_tool(0)
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		push_warning("ToolBag: No tools found in children")

func _process(delta: float) -> void:
	if current_tool:
		current_tool.process(delta)
	
func _physics_process(delta: float) -> void:
	if current_tool:
		current_tool.physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_tool:
		current_tool.handle_input(event)

# Equip a tool by index
func equip_tool(index: int) -> void:
	if index < 0 or index >= tools.size():
		push_warning("ToolBag: Invalid tool index: ", index)
		return
	
	if current_tool_index == index:
		return
	
	if current_tool:
		current_tool.exit()
	
	current_tool_index = index
	current_tool = tools[index]
	current_tool.enter()

# Equip next tool
func equip_next_tool() -> void:
	if tools.size() == 0:
		return
	var next_index = (current_tool_index + 1) % tools.size()
	equip_tool(next_index)

# Equip previous tool
func equip_previous_tool() -> void:
	if tools.size() == 0:
		return
	var prev_index = (current_tool_index - 1 + tools.size()) % tools.size()
	equip_tool(prev_index)

# Equip a tool by name
func equip_tool_by_name(tool_name: String) -> bool:
	for i in range(tools.size()):
		if tools[i].tool_name == tool_name:
			equip_tool(i)
			return true
	return false

# Get all tool names
func get_all_tool_names() -> Array[String]:
	var names: Array[String] = []
	for tool in tools:
		names.append(tool.tool_name)
	return names

# Get current tool
func get_current_tool() -> Tool:
	return current_tool

# Get current tool index
func get_current_tool_index() -> int:
	return current_tool_index
