extends TileMapLayer

@onready var main_game_node = get_tree().get_root().get_node('Main')

# Get the highlight marker node
@onready var highlighted_marker: Panel = get_node("marker") 
# Replace "HighlightedMarker" with the actual name of your child node

var last_hovered_coords: Vector2i = Vector2i(-1, -1)

@onready var tile_set_resource: TileSet = tile_set
# Adjust this to the source ID where your atlas image is located
const TARGET_SOURCE_ID: int = 0

func _ready() -> void:
	pass
	
func _input(event):
	# Check if the event is a left mouse button click being released
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed == false:
	if event.is_action_pressed("pop"):
		
		# 1. Get the mouse position relative to the TileMap node
		var local_mouse_pos = get_local_mouse_position()

		# 2. Convert the local position to tile coordinates (cell)
		var clicked_coords: Vector2i = local_to_map(local_mouse_pos)

		# 3. Check if a tile exists at these coordinates on the specific layer
		var tile_data = get_cell_tile_data(clicked_coords)
		
		if tile_data != null:
			
			# Get the tile's position in world space for visual effects or positioning
			var _world_position: Vector2 = map_to_local(clicked_coords)
			
			# Optionally, you can get the tile's Source ID and Atlas Coords
			var tile_atlas_coords: Vector2i = get_cell_atlas_coords(clicked_coords)
			var _tile_source_id: int = get_cell_source_id(clicked_coords)
			
			#main_game_node.gprint("Clicked Tile at Map Coords: " + str( clicked_coords))
			#main_game_node.gprint("Source ID: " + str(tile_source_id) + ", Atlas Coords: " + str(tile_atlas_coords))
			
			# --- Place your tile click action code here ---
			if str(tile_atlas_coords) in GlobalVars.BLOCK_DEFINITIONS:
				var block_definition = GlobalVars.BLOCK_DEFINITIONS[str(tile_atlas_coords)]
				if block_definition.poppable:
					# Destroy the tile
					get_node('poppedtile').play()
					set_cell(clicked_coords, -1)
					# Example: Call a function specific to this tile
					pop_tile(local_mouse_pos, tile_atlas_coords, block_definition)
			
func pop_tile(local_mouse_pos: Vector2i, tile_atlas_coords: Vector2i, given_block_definition: Dictionary):
	var popped_block = load('res://scenes/block.tscn').instantiate()
	# eventually look up names of blocks based on tile atlas coordinates, for now just
	# use the coordinates as the name
	popped_block.prepare(str(tile_atlas_coords) if given_block_definition.poppable is bool else given_block_definition.poppable, 
						get_texture_from_atlas_coords(tile_atlas_coords) if given_block_definition.poppable is bool else get_texture_from_atlas_coords(str_to_var('Vector2i' + given_block_definition.poppable)))
	popped_block.position = local_mouse_pos
	main_game_node.add_child(popped_block)
	
func _process(_delta: float):
	# 1. Get the mouse position in the viewport
	var mouse_pos_global = get_global_mouse_position()
	
	# 2. Convert the global mouse position to the TileMap's local position
	var mouse_pos_local = to_local(mouse_pos_global)
	
	# 3. Convert the local position to the grid cell coordinates (Vector2i)
	var cell_pos: Vector2i = local_to_map(mouse_pos_local)
	
	# 4. Convert the cell coordinates back to the world position (Vector2)
	var marker_world_pos: Vector2 = map_to_local(cell_pos)

	# 5. Check if the cell exists (optional, but good practice)
	# The TileMap's `get_cell_tile_data` function can be used to check
	var tile_data = get_cell_tile_data(cell_pos)

	if tile_data:
		var atlas_coords = get_cell_atlas_coords(cell_pos)
		if str(atlas_coords) in GlobalVars.BLOCK_DEFINITIONS:
			if GlobalVars.BLOCK_DEFINITIONS[str(atlas_coords)].poppable:
				# Show the marker and set its position
				highlighted_marker.visible = true
				highlighted_marker.position = to_global(marker_world_pos - Vector2(7,7))
				
				if cell_pos != last_hovered_coords:
						# 4. Play the sound and update the last hovered coordinates
						#if not mouseover_sound_player.is_playing():
						get_node('mouseover').play()
						
						last_hovered_coords = cell_pos
	else:
		# Hide the marker if the mouse is outside the defined tiles
		highlighted_marker.visible = false
		# If the mouse is now over empty space, reset the last_hovered_coords
		last_hovered_coords = Vector2i(-1, -1)

func get_texture_from_atlas_coords(atlas_coords: Vector2i) -> Texture2D:
	# 1. Get the TileSetSource object
	var source: TileSetSource = tile_set_resource.get_source(TARGET_SOURCE_ID)
	
	if not source is TileSetAtlasSource:
		print("Error: Target source is not a TileSetAtlasSource.")
		return null
		
	var atlas_source: TileSetAtlasSource = source
	
	# 2. Get the rectangular region of the tile within the entire atlas image
	var tile_rect: Rect2i = atlas_source.get_tile_texture_region(atlas_coords)
	
	if tile_rect.size.x <= 0 or tile_rect.size.y <= 0:
		print("Error: Invalid texture region for atlas coords: " + str(atlas_coords))
		return null
		
	# 3. Get the entire atlas texture and convert it to an Image
	var atlas_texture: Texture2D = atlas_source.get_texture()
	var atlas_image: Image = atlas_texture.get_image()
	
	# 4. Use Image.get_region() to extract the specific tile image
	# This is the safest way to get a clean slice of the texture data.
	var tile_image: Image = atlas_image.get_region(tile_rect)
	
	# 5. Create a new ImageTexture from the extracted image slice
	var tile_texture = ImageTexture.create_from_image(tile_image)
	
	return tile_texture
