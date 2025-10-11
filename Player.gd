extends CharacterBody2D

const speed = 50;

enum PlayerState {
	IDLE = 0,
	RUNNING = 10,
	JUMPING = 20
}

var currState = PlayerState.IDLE;

func _physics_process(delta: float) -> void:
	if currState == PlayerState.RUNNING:
		var runState = RunState.new()
		runState.enter()
		runState.physics_update(speed)
	pass
