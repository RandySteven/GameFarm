class_name WalkState extends State

@onready var idle_state : State = $"../Idle"
@export var move_speed: float = 300.0 

func enter() -> void:
	player.UpdateAnimation("walk")
	
func process(_delta : float) -> State:
	if player.direction == Vector2.ZERO:
		return idle_state
	
	player.velocity = player.direction * move_speed
	
	if player.SetDirection():
		player.UpdateAnimation("walk")
	
	return null
