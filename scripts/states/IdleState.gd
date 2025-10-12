class_name IdleState extends State

@onready var walk_state : State = $"../Walk"

func enter() -> void:
	player.UpdateAnimation("idle")

func process(delta : float) -> State:
	if player.direction != Vector2.ZERO:
		return walk_state
	player.velocity = Vector2.ZERO
	return null
