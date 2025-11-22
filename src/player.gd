extends CharacterBody2D

var main_game_node = Node2D

var is_player:bool = true

var inventory = {}

var destination_vector = null

var mouse_walking: bool = false

# Exported variable allows you to change the speed directly in the Inspector
@export var speed: float = 400.0 

func _ready() -> void:
	main_game_node = get_tree().get_root().get_node('Main')
	
func move_to(given_vector: Vector2):
	mouse_walking = true
	destination_vector = given_vector
	
func stop_mouse_walking():
	mouse_walking = false

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
		
	# 1. Get Input Direction
	# This combines the 'ui' input actions (mapped to arrow keys/WASD by default)
	# into a single normalized Vector2.
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
	if input_direction != Vector2.ZERO:
		# kill the destination vector
		mouse_walking = false
			
	if mouse_walking:
		#print(self.global_position - destination_vector)
		if self.global_position.distance_squared_to(destination_vector) < 0.1:
			mouse_walking = false
			velocity = Vector2.ZERO

	# 2. Calculate New Velocity
	# The velocity variable is built into CharacterBody2D.
	# We multiply the normalized direction vector by the desired speed.
	if not mouse_walking:
		velocity = input_direction * speed
	else:
		velocity = (destination_vector - self.global_position).normalized() * speed
		
	if velocity != Vector2.ZERO:
		if not $AnimatedSprite2D.is_playing() and not Input.is_action_pressed("pop"):
			$AnimatedSprite2D.play("walk")
		if not get_node('walking').playing:
			get_node('walking').play()
	else:
		# play pop animation if needed
		if Input.is_action_just_pressed("pop"):
			$AnimatedSprite2D.play("pop")
			
	# You can add animation updates here, e.g.,
	#print(velocity.x)
	#if velocity.x != 0:
	#	$AnimatedSprite2D.flip_h = velocity.x < 0
	if abs(velocity.x) > 0:
		transform.x.x = sign(velocity.x)

	# 3. Move and Slide
	# This is the core Godot 4 movement function. It attempts to move the body 
	# and handles collisions, sliding along obstacles.
	move_and_slide()

func add_block(block_atlas_coords:String, block_texture: Texture2D):
	#if not get_node('pickup').playing:	
	if block_atlas_coords in inventory:
		inventory[block_atlas_coords]['count'] += 1
	else:
		inventory[block_atlas_coords] = {'texture': block_texture, 'count' : 1, 'name': GlobalVars.BLOCK_DEFINITIONS[block_atlas_coords]['name']}
	main_game_node.gprint('Picked up ' + GlobalVars.BLOCK_DEFINITIONS[block_atlas_coords]['name'])
	get_node('pickup').play()
	main_game_node.update_inventory_ui(self.inventory)

func place_block(block_atlas_coords:String, tilemap_coords: Vector2i, block_texture: Texture2D):
	if block_atlas_coords in inventory:
		if inventory[block_atlas_coords]['count'] == 1:
			main_game_node.gprint('Placed down ' + GlobalVars.BLOCK_DEFINITIONS[block_atlas_coords]['name'])
			inventory.erase(block_atlas_coords)
		else:
			main_game_node.gprint('Placed down ' + GlobalVars.BLOCK_DEFINITIONS[block_atlas_coords]['name'])
			inventory[block_atlas_coords]['count'] -= 1
		
		get_node('pickup').play()
		main_game_node.update_inventory_ui(self.inventory)
