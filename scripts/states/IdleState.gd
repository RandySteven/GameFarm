class_name IdleState extends State

@onready var walk_state : State = $"../Walk"
@onready var scope_state : State = $"../Scope"
@onready var water_state : State = $"../Water"

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
	
	return null	
