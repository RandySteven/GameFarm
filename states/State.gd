extends Node

class_name State

var player_node: CharacterBody2D

var state_machine: Node

func setup(p_player_node: CharacterBody2D, p_state_machine: Node) -> void:
	self.player_node = p_player_node
	self.state_machine = p_state_machine

func enter() -> void:
	pass

func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	
	pass

func physics_update(_delta: float) -> void:
	pass

func update(_delta: float) -> void:
	pass
