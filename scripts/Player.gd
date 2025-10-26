class_name Player extends CharacterBody2D

#@onready var state_machine: StateMachine = $StateMachine
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var move_speed : float = 100.0
var state : String = "idle"
var current_tool : Tool

var stamina : int = 100

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var farmerEffectSprite : Sprite2D = $Sprite2D/FarmerEffectSprite
@onready var state_machine : PlayerStateMachine = $StateMachine

@onready var tool_bag : ToolBag = $ToolBag

func _ready() -> void:
	state_machine.initialize(self)

func _process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")


func _physics_process(delta: float) -> void:
	#move_and_slide()
	update_movement(delta)

func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false

	var new_dir : Vector2 = cardinal_direction
	
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN

	if new_dir == cardinal_direction:
		return false

	cardinal_direction = new_dir

	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1

	return true
	
func set_state() -> bool:
	var new_state : String = "idle" if direction == Vector2.ZERO else "walk"
	if new_state == state:
		return false
	state = new_state
	return true

func update_animation(state_name : String) :
	var curr_state : String = state_name + "_" + animation_direction() 
	sprite.play(curr_state)
	sprite.visible = true

func stop_animation() :
	sprite.stop()

func on_transition():
	if !sprite.is_playing():
		update_animation("idle")
	
func animation_direction() :
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func decrease_stamina(minus : int) -> void:
	stamina -= minus
	
func increase_stamina(plus : int) -> void:
	stamina += plus

func update_movement(delta: float):
	velocity = direction * move_speed
	state_machine._physics_process(delta)
	move_and_slide()

func sprite_is_playing() -> bool :
	return sprite.is_playing()
