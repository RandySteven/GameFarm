extends State

class_name IdleState

var animated_sprite: AnimatedSprite2D

func enter() -> void:
	animated_sprite = player_node.get_node("AnimatedSprite2D")
	animated_sprite.play("idle")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left") or event.is_action_pressed("move_right"):
		state_machine.transition_to("RunState")
	elif event.is_action_pressed("ui_accept"):  # Assuming Enter/Space for checking bag
		state_machine.transition_to("CheckBagState")
