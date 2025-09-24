extends Node

enum PlayerState {
	IDLE = 0,
	RUNNING = 10,
	JUMPING = 20
}

@export var idle      = "idle"
@export var run       = "run"
@export var check_bag = "check_bag"
