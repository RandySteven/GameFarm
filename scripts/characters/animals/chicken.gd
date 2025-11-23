extends NonPlayableCharacter

@onready var sprite2D = $AnimatedSprite2D
@onready var navigationRegion2D = $NavigationRegion2D
@onready var navigationAgent = $NavigationAgent2D
@onready var timer = $Timer

# Health/Life properties
@export var max_health: int = 100
var current_health: int

# Movement properties
var speed = 100
var direction = Vector2.ZERO
var target_position: Vector2
var is_moving: bool = false
var idle_timer: float = 0.0
var idle_duration: float = 0.0
	
func _ready() -> void:
	# Initialize health
	current_health = max_health
	
	# Setup navigation agent
	navigationAgent.path_desired_distance = 4.0
	navigationAgent.target_desired_distance = 4.0
	# Wait for navigation to be ready
	call_deferred("setup_navigation")
	
	# Setup timer for changing direction
	timer.wait_time = randi_range(2, 5)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
	sprite2D.play("idle")
	randomize() # Initialize random number generator

func setup_navigation():
	# Wait for the first frame to ensure navigation map is ready
	await get_tree().physics_frame
	navigationAgent.set_navigation_map(navigationRegion2D.get_navigation_map())
	pick_new_target()

func pick_new_target():
	# Get a random point within the navigation polygon
	var nav_poly = navigationRegion2D.navigation_polygon
	if nav_poly == null:
		return
	
	# Get the polygon vertices (these are in local coordinates relative to NavigationRegion2D)
	var outlines = nav_poly.get_outline(0)
	if outlines.size() == 0:
		return
	
	# Convert outlines to global coordinates
	var region_global_pos = navigationRegion2D.global_position
	var global_outlines = PackedVector2Array()
	for point in outlines:
		global_outlines.append(region_global_pos + point)
	
	# Find bounding box of the polygon in global coordinates
	var min_x = global_outlines[0].x
	var max_x = global_outlines[0].x
	var min_y = global_outlines[0].y
	var max_y = global_outlines[0].y
	
	for point in global_outlines:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
	
	# Try to find a valid point within the polygon
	var attempts = 0
	var valid_point = false
	var test_point: Vector2
	
	while not valid_point and attempts < 50:
		# Generate random point within bounding box (in global coordinates)
		test_point = Vector2(
			randf_range(min_x, max_x),
			randf_range(min_y, max_y)
		)
		
		# Check if point is inside the polygon (using global coordinates)
		if Geometry2D.is_point_in_polygon(test_point, global_outlines):
			valid_point = true
			target_position = test_point
			navigationAgent.target_position = target_position
			is_moving = true
			sprite2D.play("walk")
		attempts += 1

func change_direction():
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	pick_new_target()

func _on_timer_timeout():
	# Change direction periodically
	change_direction()
	# Set random wait time for next direction change
	timer.wait_time = randi_range(2, 5)
	
func _physics_process(delta):
	if not navigationAgent.is_navigation_finished():
		var next_path_position = navigationAgent.get_next_path_position()
		direction = global_position.direction_to(next_path_position)
		velocity = direction * speed
		move_and_slide()
		idle_timer = 0.0  # Reset idle timer when moving
	else:
		# Reached target, wait a bit before picking new target
		if is_moving:
			is_moving = false
			sprite2D.play("idle")
			idle_timer = 0.0
			idle_duration = randf_range(1.0, 3.0)
		
		# Handle idle period before picking new target
		if not is_moving and idle_duration > 0.0:
			idle_timer += delta
			if idle_timer >= idle_duration:
				idle_timer = 0.0
				idle_duration = 0.0
				pick_new_target()

# Health management functions
func take_damage(amount: int) -> void:
	current_health = max(0, current_health - amount)
	if current_health <= 0:
		die()

func heal(amount: int) -> void:
	current_health = min(max_health, current_health + amount)

func die() -> void:
	# Handle chicken death
	print("Chicken died!")
	queue_free()
