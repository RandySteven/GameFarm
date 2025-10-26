class_name WaterState extends State

@export_range(1.0, 20.0, 0.5) var decelerate_speed: float = 5.0
@export_range(0.1, 1.0, 0.05) var water_move_multiplier: float = 0.5

@onready var idle_state : State = $"../Idle"
@onready var walk_state : State = $"../Walk"

var original_speed: float = 0.0
var watering : bool = false
var exit_timer : float = 0.0
var exit_started : bool = false

func enter() -> void:
	original_speed = player.move_speed
	player.update_animation("water")
	watering = true
	exit_timer = 0.0
	exit_started = false

func on_next_transition() -> void:
	if !player.sprite.is_playing():
		transition.emit("idle")

func process(_delta : float) -> State:
	if not Input.is_action_pressed("water"):
		player.velocity = Vector2.ZERO
		
		if not exit_started:
			exit_started = true
			exit_timer = 0.4  
			player.update_animation("water")
		
		exit_timer -= _delta
		if exit_timer > 0.0:
			return null
		
		return idle_state

	exit_started = false
	exit_timer = 0.0
	
	if player.direction != Vector2.ZERO:
		player.velocity = player.direction * player.move_speed
		
		player.set_direction() 
		player.update_animation("walk") 
		
	elif player.velocity.length_squared() > 0.0:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, decelerate_speed * _delta)
		player.update_animation("water") 
		
	else:
		player.velocity = Vector2.ZERO
		player.update_animation("water")

	return null

func exit() -> void:
	player.move_speed = original_speed
	watering = false
	exit_timer = 0.0
	exit_started = false
