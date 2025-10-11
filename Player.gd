extends CharacterBody2D

@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	# The state machine will automatically initialize and set up states
	pass

func _physics_process(delta: float) -> void:
	# State machine handles physics updates
	pass

func _process(delta: float) -> void:
	# State machine handles regular updates
	pass

func _unhandled_input(event: InputEvent) -> void:
	# State machine handles input
	pass
