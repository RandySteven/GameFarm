class_name PlayerStateMachine extends Node

var states: Array[State] = []
var previous_state: State
var current_state: State

func _ready() -> void: # [00:09:04]
	process_mode = Node.PROCESS_MODE_DISABLED

func initialize(player: CharacterBody2D) -> void: # [00:12:15]
	states = []
	
	for child in get_children(): # [00:12:40]
		if child is State:
			states.append(child)

	if states.size() > 0:
		State.player = player # [00:15:44]
		
		change_state(states[0]) # [00:15:52]
		
		process_mode = Node.PROCESS_MODE_INHERIT # [00:16:08]

func _process(delta: float) -> void: # [00:16:47]
	var new_state: State = current_state.process(delta)
	if new_state != null:
		change_state(new_state) 

func _physics_process(delta: float) -> void: # [00:17:54]
	var new_state: State = current_state.physics(delta)
	if new_state != null:
		change_state(new_state)

func _unhandled_input(event: InputEvent) -> void: # [00:18:24]
	var new_state: State = current_state.handle_input(event)
	if new_state != null:
		change_state(new_state)

func change_state(new_state: State) -> void: # [00:09:27]
	if new_state == null or new_state == current_state: # [00:10:13]
		return

	if current_state: # [00:11:05]
		current_state.exit()

	previous_state = current_state # [00:11:21]
	current_state = new_state # [00:11:29]

	current_state.enter() # [00:11:37]
