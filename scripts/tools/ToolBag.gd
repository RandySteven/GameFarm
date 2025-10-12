class_name ToolBag extends Node

var tools : Array[Tool] = []
var current_tool : Tool

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	
func initialize(player : CharacterBody2D):
	tools = []
	
	for child in get_children():
		if child is Tool:
			tools.append(child)
	
	if tools.size() > 0:
		Tool.player = player
		
		change_curr_tool(tools[0])
		process_mode = Node.PROCESS_MODE_INHERIT

func _process(delta: float) -> void:
	change_curr_tool(current_tool.process(delta))
	
func _physics_process(delta: float) -> void:
	change_curr_tool(current_tool.physics(delta))

func _unhandled_input(event: InputEvent) -> void: # [00:18:24]
	change_curr_tool(current_tool.handle_input(event))

func change_curr_tool(change_tool : Tool) -> void:
	if change_tool == null || current_tool == change_tool:
		return
	
	if current_tool:
		current_tool.exit()
	
	current_tool = change_tool
	current_tool.enter()
