extends State
class_name RunState

var animated_sprite: AnimatedSprite2D
var move_speed: float = 300.0
var friction: float = 0.95 

func enter() -> void:
	animated_sprite = player_node.get_node("AnimatedSprite2D")
	animated_sprite.play("run")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):  # Check bag while running
		state_machine.transition_to("CheckBagState")

func physics_update(_delta: float) -> void:
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	var vertical_direction = Input.get_axis("move_up", "move_down")

	var direction = Vector2(horizontal_direction, vertical_direction).normalized()
	
	if direction != Vector2.ZERO:
		player_node.velocity = direction * move_speed
		
		if horizontal_direction < 0:
			animated_sprite.flip_h = true
		elif horizontal_direction > 0:
			animated_sprite.flip_h = false
	else:
		player_node.velocity *= friction
		
		if player_node.velocity.length() < 5.0:
			player_node.velocity = Vector2.ZERO
			state_machine.transition_to("IdleState")
			
	player_node.move_and_slide()
