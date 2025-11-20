extends CharacterBody2D

var main_game_node = Node2D

var is_player:bool = true

var inventory = {}

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
	
	if velocity != Vector2.ZERO:
		if not $AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play("default")
		if not get_node('walking').playing:
			get_node('walking').play()
	else:
		$AnimatedSprite2D.stop()
	# You can add animation updates here, e.g.,
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		

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
