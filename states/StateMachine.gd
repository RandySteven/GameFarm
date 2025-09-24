extends Node

class_name StateMachine

var states: Dictionary = {}
var current_state: State = null

@export var player_node: CharacterBody2D

func _ready() -> void:
	for child in get_children():
		if child is State:
			var state_instance = child as State
			state_instance.setup(player_node, self)
			states[state_instance.get_class()] = state_instance
			
	if not states.is_empty():
		transition_to(states.keys()[0])
	
func _physics_process(delta: float) -> void:
	if current_state != null:
		current_state.physics_update(delta)

func _process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state != null:
		current_state.handle_input(event)
		
func transition_to(state_name: String) -> void:
	if not states.has(state_name):
		return
		
	if current_state != null:
		current_state.exit()
		
	current_state = states[state_name]
	current_state.enter()
