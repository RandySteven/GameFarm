class_name Tool extends Node

static var player: CharacterBody2D

func enter() -> void:
	pass

func exit() -> void:
	pass
	
func process(delta : float) -> Tool:
	return null

func physics(delta : float) -> Tool:
	return null

func handle_input(event : InputEvent) -> Tool:
	return null

func upgrade(next_level : String) -> bool:
	return false

static func set_player(player : CharacterBody2D) -> void:
	player = player
