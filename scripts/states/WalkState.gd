class_name WalkState extends State

@onready var idle_state : State = $"../Idle"
@export var move_speed: float = 300.0 

func enter() -> void:
	player.update_animationdwadwasd("walk")
	
func process(_delta : float) -> State:
	if player.direction == Vector2.ZERO:
		return idle_state
	
	player.velocity = player.direction * move_speed
	
	if player.set_direction():
		player.update_animation("walk")
	
	return null
