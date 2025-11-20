extends Node2D

# The node to move towards (usually set when the player enters a detection area)
var target_node: Node2D = null 
var current_velocity: Vector2 = Vector2.ZERO

const MAX_SPEED: float = 200.0 # Fast speed for attraction
const ATTRACT_DISTANCE: float = 50.0 # Distance to start moving
const ACCELERATION: float = 250.0 # How quickly the item speeds up

func _process(delta):
	if target_node:
		var distance_to_target = global_position.distance_to(target_node.global_position)
		
		# 1. Check if the player is close enough to start attraction
		if distance_to_target <= ATTRACT_DISTANCE:
			
			# 2. Calculate the normalized direction vector
			var direction: Vector2 = global_position.direction_to(target_node.global_position)
			
			# 3. Accelerate towards the target
			current_velocity += direction * ACCELERATION * delta
			
			# 4. Clamp (limit) the speed
			if current_velocity.length() > MAX_SPEED:
				current_velocity = current_velocity.normalized() * MAX_SPEED
			
			# 5. Apply the movement
			global_position += current_velocity * delta
			
			# Optional: Snap to target when very close (prevents jiggling)
			if distance_to_target < 15:
				global_position = target_node.global_position
				target_node.add_block('default_block_type')
				queue_free()

func _on_body_entered(body: Node2D) -> void:
	if 'is_player' in body:
		if body.is_player:
			target_node = body

	
