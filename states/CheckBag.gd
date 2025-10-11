extends State

class_name CheckBagState

var animated_sprite: AnimatedSprite2D

func enter() -> void:
	animated_sprite = player_node.get_node("AnimatedSprite2D")
	animated_sprite.play("check_bag")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("move_left") or event.is_action_pressed("move_right"):
		state_machine.transition_to("IdleState")

func physics_update(_delta: float) -> void:
	# Player stays still while checking bag
	player_node.velocity = Vector2.ZERO
	player_node.move_and_slide()
