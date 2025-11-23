extends Node

var player_data
var lore_data

# Use the preload() function if you know the file path at compile time.
# Replace "res://path/to/your_tileset.tres" with your actual file path.
const TILESET_PATH = "res://assets/tileset.tres"

var BLOCK_DEFINITIONS = {
	'(0, 7)': {
		'name': 'dirt1', # name of the block
		'poppable': false, # if it can popped out in pop mode
		'placeable': false, # if it can be placed in place mode
		'replaceable': true # if it can be replaced in place mode
	},
	'(1, 7)': {
		'name': 'dirt2',
		'poppable': false,
		'placeable': false,
		'replaceable': true
	},
	'(2, 7)': {
		'name': 'dirt3',
		'poppable': false,
		'placeable': false,
		'replaceable': true
	},
	'(0, 34)': {
		'name': 'tree1',
		'poppable': '(0, 23)',
		'placeable': false,
		'replaceable': false
	},
	'(1, 34)': {
		'name': 'tree2',
		'poppable': '(0, 23)',
		'placeable': false,
		'replaceable': false
	},
	'(2, 34)': {
		'name': 'tree3',
		'poppable': '(0, 23)',
		'placeable': false,
		'replaceable': false
	},
	'(3, 34)': {
		'name': 'tree3',
		'poppable': '(0, 23)',
		'placeable': false,
		'replaceable': false
	},
	'(15, 34)': {
		'name': 'quarry',
		'poppable': '(79, 20)',
		'placeable': false,
		'replaceable': false
	},
	'(79, 20)': {
		'name': 'stone',
		'poppable': true,
		'placeable': false,
		'replaceable': false
	},
	'(0, 23)': {
		'name': 'wood',
		'poppable': true,
		'placeable': false,
		'replaceable': false
	},
	'(0, 4)': {
		'name': 'wood_wall_1',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(0, 23)': 1
		}
	},
	'(1, 4)': {
		'name': 'wood_wall_2',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(0, 23)': 1
		}
	},
	'(2, 4)': {
		'name': 'wood_wall_3',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(0, 23)': 1
		}
	},
	'(3, 4)': {
		'name': 'wood_wall_4',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(0, 23)': 1
		}
	},
	'(4, 4)': {
		'name': 'wood_wall_5',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(0, 23)': 1
		}
	},
	'(5, 4)': {
		'name': 'wood_wall_6',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(0, 23)': 1
		}
	},
	'(6, 4)': {
		'name': 'wood_wall_7',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(0, 23)': 1
		}
	},
	'(7, 4)': {
		'name': 'wood_wall_8',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(0, 23)': 1
		}
	},
	'(8, 4)': {
		'name': 'wood_wall_9',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(0, 23)': 1
		}
	},
	'(9, 4)': {
		'name': 'wood_wall_10',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(0, 23)': 1
		}
	},
	'(10, 4)': {
		'name': 'wood_wall_11',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(0, 23)': 1
		}
	},
	'(13, 4)': {
		'name': 'wood_door_1',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(0, 23)': 2
		}
	},
	'(14, 4)': {
		'name': 'wood_door_2',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(0, 23)': 2
		}
	},
	'(15, 4)': {
		'name': 'wood_door_3',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(0, 23)': 2
		}
	},
	'(0, 2)': {
		'name': 'cracked_stone_floor_1',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(79, 20)': 1
		}
	},
	'(1, 2)': {
		'name': 'cracked_stone_floor_2',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(79, 20)': 1
		}
	},
	'(5, 2)': {
		'name': 'stone_floor_1',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(79, 20)': 3
		}
	},
	'(6, 2)': {
		'name': 'stone_floor_2',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(79, 20)': 2
		}
	},
	'(7, 2)': {
		'name': 'stone_floor_3',
		'poppable': true,
		'placeable': true,
		'replaceable': false,
		'ingredients': {
			'(79, 20)': 2
		}
	}
}

# adds every other tile in the atlas not already defined and by default make it poppable and placeable
# for debugging and testing purposes
func load_other_block_definitions():
	# Load the TileSet resource
	var tileset: TileSet = load(TILESET_PATH)
	
	if tileset == null:
		print("Error: Could not load TileSet resource from path: ", TILESET_PATH)
		return
	
	# 1. Get all source IDs in the TileSet
	var source_ids: Array[int] = [0]

	for source_id in source_ids:
		# 2. Get the specific TileSetSource
		var tile_source: TileSetSource = tileset.get_source(source_id)
		
		# 3. Check if the source is an Atlas Source (the type that holds coordinates)
		if tile_source is TileSetAtlasSource:
			var atlas_source: TileSetAtlasSource = tile_source as TileSetAtlasSource
			
			var water_pattern = tileset.get_pattern(0)
			var water_pattern_tiles = []
			for x in range(water_pattern.get_size().x):
				for y in range(water_pattern.get_size().y):
					var local_coord = Vector2i(x, y)
					var atlas_coord: Vector2i = water_pattern.get_cell_atlas_coords(local_coord)
					water_pattern_tiles.append(str(atlas_coord))
					
			# Iterate over the primary tiles in the atlas (indexed by coordinates)
			for x in atlas_source.get_atlas_grid_size().x:
				for y in atlas_source.get_atlas_grid_size().y:
					var atlas_coords = Vector2i(x, y)
					if atlas_source.has_tile(atlas_coords):
						# see if the atlas coords are not in the block definition (or in a special reserved pattern)
						if not str(atlas_coords) in BLOCK_DEFINITIONS and not str(atlas_coords) in water_pattern_tiles: 
						
							# Access the main tile data
							#var tile_data = atlas_source.get_tile_data(atlas_coords, 0)
							# Blocks that aren't explicitly defined should not be poppable but could be palced
							BLOCK_DEFINITIONS[str(atlas_coords)] = {
								'name': 'GENERIC TILE',
								'poppable': true,
								'placeable': true,
								'replaceable':false
							}
							#print("Added generic tile at Atlas Coords %s: %s" % [atlas_coords, tile_data])
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get lore data
	#var file = FileAccess.open("res://lore/lore.json", FileAccess.READ)
	#lore_data = JSON.parse_string(file.get_as_text())
	#file.close()
	#load_default_player_data()
	
	self.load_other_block_definitions()
	
	# check if save directory exists
	var dir = DirAccess.open("user://")
	if not dir.dir_exists('saves'):
		dir.make_dir('saves')

func load_default_player_data():
	# get player data (default one in lore file)
	var file = FileAccess.open("res://lore/lore.json", FileAccess.READ)
	player_data = JSON.parse_string(file.get_as_text())['character']
	file.close()

func load_player_data(path):
	var file = FileAccess.open(path, FileAccess.READ)
	player_data = JSON.parse_string(file.get_as_text())
	file.close()
	
func save_player_data():
	var file = FileAccess.open("user://saves/" + GlobalVars.player_data['name'] + '.json', FileAccess.WRITE)
	file.store_string(JSON.stringify(GlobalVars.player_data))
	file.close()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# useful function for searching through a list of json documents 
# and retrieving the value for a key for a document that has a certain id
func searchDocsInList(list, uniquekey: String, uniqueid: String, key: String):
	for doc in list:
		if doc[uniquekey] == uniqueid:
			if key in doc.keys():
				return doc[key]
			else:
				return null
	return null

# useful function for searching through a list of json documents
# and retrieving doc where there is a certain value for a certain key
func returnDocInList(list, uniquekey, uniqueid):
	for doc in list:
		if doc[uniquekey] == uniqueid:
			return doc
	return null
	
# useful function for making an array unique
func array_unique(array: Array) -> Array:
	var unique: Array = []
	for item in array:
		if not unique.has(item):
			unique.append(item)
	return unique

#useful function for picking a random value from a list
func choose_random_from_list(rand_list):
	return rand_list[randi() % rand_list.size()]

#useful function for returning a list of files in a directory
func dir_contents(path):
	var files = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				#print("Found directory: " + file_name)
				pass
			else:
				if file_name.find('.import') == -1:
					#print("Found file: " + file_name)
					files.append(file_name)
			file_name = dir.get_next()
	else:
		#print("An error occurred when trying to access the path.")
		pass
	return files
