extends CharacterBody2D

## --- Exports & Variables ---

# Movement speed (pixels per second)
@export var speed: float = 50.0

# How long the NPC moves in one direction before choosing a new one (in seconds)
@export var direction_time_min: float = 1.0
@export var direction_time_max: float = 3.0

# Internal timer for the current movement direction
var direction_timer: float = 0.0

# The current velocity vector
var current_velocity: Vector2 = Vector2.ZERO

## --- Movement Logic ---

func _ready():
	# Be a random animal
	$AnimatedSprite2D.frame = randi_range(0, 17)
	# Initialize with the first random movement
	_set_new_random_velocity()

func _physics_process(delta):
	# Update the countdown timer
	direction_timer -= delta
	
	# If the timer runs out, pick a new direction and reset the timer
	if direction_timer <= 0:
		_set_new_random_velocity()
	
	# Apply the current velocity for the CharacterBody2D movement
	velocity = current_velocity
	move_and_slide()

## --- Helper Functions ---

# Function to choose a new random velocity vector and reset the timer
func _set_new_random_velocity():
	# 1. Choose a random angle (in radians)
	var random_angle: float = randf_range(0, TAU) # TAU is 2 * PI (a full circle)
	
	# 2. Convert the angle to a unit vector (length 1)
	var direction_vector: Vector2 = Vector2.from_angle(random_angle)
	
	# 3. Calculate the new velocity (Direction * Speed)
	current_velocity = direction_vector * speed
	
	# 4. Set a new random duration for the movement
	direction_timer = randf_range(direction_time_min, direction_time_max)
	
	# You can add animation updates here, e.g.,
	if current_velocity.x != 0:
		$AnimatedSprite2D.flip_h = current_velocity.x > 0
	# if current_velocity.length() > 0:
	#     $AnimatedSprite2D.play("walk")
	# else:
	#     $AnimatedSprite2D.play("idle")
