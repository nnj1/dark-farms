extends CharacterBody2D

var main_game_node = Node2D

var is_player:bool = true

# Exported variable allows you to change the speed directly in the Inspector
@export var speed: float = 400.0 

func _ready() -> void:
	main_game_node = get_tree().get_root().get_node('Main')

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	# 1. Get Input Direction
	# This combines the 'ui' input actions (mapped to arrow keys/WASD by default)
	# into a single normalized Vector2.
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# 2. Calculate New Velocity
	# The velocity variable is built into CharacterBody2D.
	# We multiply the normalized direction vector by the desired speed.
	velocity = input_direction * speed

	# 3. Move and Slide
	# This is the core Godot 4 movement function. It attempts to move the body 
	# and handles collisions, sliding along obstacles.
	move_and_slide()

func add_block(_block_name:String):
	#if not get_node('pickup').playing:
	get_node('pickup').play()
