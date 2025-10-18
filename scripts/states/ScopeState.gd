class_name ScopeState extends State

@export_range(1.0, 20.0, 0.5) var decelerate_speed: float = 5.0
@export var scope_sound : AudioStream 

@onready var animator : AnimationPlayer = $"../../AnimationPlayer"

@onready var idle_state : State = preload("res://scripts/states/IdleState.gd").new()
@onready var walk_state : State = preload("res://scripts/states/WalkState.gd").new()

var scoping : bool = false

func enter():
	player.update_animation("scope")
	animator.animation_finished.connect(end_action)
	scoping = true

func process(_delta : float) -> State:
	#if player.current_tool == null || player.current_tool != Scope:
		#return idle_state
	#
	#player.current_tool.process(_delta)
	if player.velocity.length() > 0:
		player.velocity -= player.velocity * decelerate_speed * _delta
	
	if scoping == false:
		if player.direction == Vector2.ZERO:
			return idle_state
		else:
			return walk_state
	
	return null

func end_action(_anim_name : String): 
	scoping = false
	
func exit():
	if animator.animation_finished.is_connected( end_action ):
		animator.animation_finished.disconnect( end_action )
	scoping = false
