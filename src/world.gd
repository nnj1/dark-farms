extends Node2D

@onready var main_game_node = get_tree().get_root().get_node('Main')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: use gaia to generate the map again if needed
	
	# populate the map with animals
	#Get the used cells in the specified layer.
	var used_cells = get_node('map').get_used_cells()
	
	var valid_player_spawn_coords = []

	# Loop through each used cell's map coordinates.
	for cell_coords in used_cells:
		# Get the source ID and atlas coordinates for the current cell.
		var _source_id = get_node('map').get_cell_source_id(cell_coords)
		var atlas_coords = get_node('map').get_cell_atlas_coords(cell_coords)
		if str(atlas_coords) in GlobalVars.BLOCK_DEFINITIONS:
			if GlobalVars.BLOCK_DEFINITIONS[str(atlas_coords)].name in ['dirt1', 'dirt2', 'dirt3']:
				# can spawn an animal on one of these dirt patches
				if randf_range(0,1) < 0.01:
					var animal = preload('res://scenes/animal.tscn').instantiate()
					var local_position = get_node('map').map_to_local(cell_coords)
					animal.position = to_global(local_position)
					get_node('npcs').add_child(animal)
				else:
					var local_position = get_node('map').map_to_local(cell_coords)
					valid_player_spawn_coords.append(to_global(local_position))
				# can also potentially spawn player here
	
	# move the player to an appopriate spawn point
	main_game_node.get_node('entities/player').position = valid_player_spawn_coords.pick_random()
	
func _process(_delta: float) -> void:
	pass
