class_name State extends Node

static var player: CharacterBody2D
static var animated_sprite_2d : AnimatedSprite2D

var state_machine: Node
signal transition

func enter() -> void:
	pass

func exit() -> void:
	pass

func on_next_transition() -> void:
	pass
	
func process(delta : float) -> State:
	return null

func physics(delta : float) -> State:
	return null

func handle_input(event : InputEvent) -> State:
	return null

static func set_player(player : CharacterBody2D) -> void:
	player = player
