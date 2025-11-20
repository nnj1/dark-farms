extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: use gaia to generate the map again if needed
	# populate the map with animals
	#Get the used cells in the specified layer.
	var used_cells = get_node('map').get_used_cells()

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

func _process(_delta: float) -> void:
	pass
