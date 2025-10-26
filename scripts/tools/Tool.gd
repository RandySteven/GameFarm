class_name Tool extends Node

static var player: CharacterBody2D
var tool_name: String = "Unknown Tool"
var level: String = "basic"

# Called when tool is equipped
func enter() -> void:
	print("Tool equipped: ", tool_name)

# Called when tool is unequipped
func exit() -> void:
	print("Tool unequipped: ", tool_name)
	
# Process called every frame
func process(_delta : float) -> void:
	pass

# Physics process called every physics frame
func physics(_delta : float) -> void:
	pass

# Handle input events
func handle_input(_event : InputEvent) -> void:
	pass

# Upgrade the tool to next level
func upgrade(next_level : String) -> bool:
	if next_level == level:
		return false
	
	level = next_level
	return true

# Get the display name of the tool
func get_display_name() -> String:
	return "%s (%s)" % [tool_name, level]

# Check if tool can be upgraded
func can_upgrade_to(next_level: String) -> bool:
	var upgrade_order = ["steel", "copper", "silver", "gold", "diamond"]
	var current_index = upgrade_order.find(level)
	var next_index = upgrade_order.find(next_level)
	
	if current_index == -1 or next_index == -1:
		return false
	
	return next_index > current_index

static func set_player(p : CharacterBody2D) -> void:
	Tool.player = p
