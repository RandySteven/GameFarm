extends NonPlayableCharacter

@onready var sprite2D = $AnimatedSprite2D
@onready var navigationRegion2D = $NavigationRegion2D

var speed = 100
var direction = Vector2.ZERO
	
func _ready() -> void:
	sprite2D.play("idle")
	randomize() # Initialize random number generator
	change_direction()

func change_direction():
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	
func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()
