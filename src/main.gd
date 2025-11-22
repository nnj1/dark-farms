extends Node2D

# Load the cursor texture at the beginning
var CURSOR_TEXTURE_PATH: String
var SCALE_FACTOR: float 

# Set the hotspot (the active click point) of the cursor.
# If your image is 64x64, a hotspot of (32, 32) centers the click point.
# For an arrow cursor, (0, 0) is usually best.
var CURSOR_HOTSPOT: Vector2

func change_cursor(texture_path:String = "res://assets/Megabyte Games Mouse Cursor Pack-2022-3-27/Megabyte Games Mouse Cursor Pack/16x16/png/cursor-pointer-18.png",
					hotspot: Vector2 = Vector2(0, 0), scale_factor: float = 1.5):
	CURSOR_TEXTURE_PATH = texture_path
	SCALE_FACTOR = scale_factor
	CURSOR_HOTSPOT = hotspot
	
	var original_texture = load(CURSOR_TEXTURE_PATH)

	if original_texture and original_texture is Texture2D:
		var original_image: Image = original_texture.get_image()
		if original_image == null:
			print("Error: Could not get image from texture.")
			return

		var new_width = int(original_image.get_width() * SCALE_FACTOR)
		var new_height = int(original_image.get_height() * SCALE_FACTOR)
		
		# 1. Create a deep copy of the original image
		var scaled_image: Image = original_image.duplicate()
		
		# 2. Use Image.resize() for high-quality scaling
		# The default Image.INTERPOLATE_LINEAR ensures smooth scaling.
		scaled_image.resize(new_width, new_height, Image.INTERPOLATE_NEAREST) 

		# 3. Create the new texture and set the cursor
		var scaled_texture = ImageTexture.create_from_image(scaled_image)

		# Recalculate hotspot (if your original hotspot was not 0,0)
		var new_hotspot = CURSOR_HOTSPOT * SCALE_FACTOR
		
		Input.set_custom_mouse_cursor(scaled_texture, Input.CURSOR_ARROW, new_hotspot)
		print("Cursor scaled successfully using Image.resize().")
	else:
		print("Error: Could not load or cast the original cursor texture.")
	
func _ready() -> void:
	self.change_cursor()
	
func update_inventory_ui(given_inventory) -> void:
	for slot in get_node('UI/TabContainer/Inventory/Grid').get_children():
		slot.queue_free()
	for block_name in given_inventory:
		var slot = preload('res://scenes/slot.tscn').instantiate()
		slot.prepare(given_inventory[block_name]['name'], given_inventory[block_name]['count'], given_inventory[block_name]['texture'], block_name)
		get_node('UI/TabContainer/Inventory/Grid').add_child(slot)
		
	# if the player has been in placing mode, activate the slot that they've been placing:
	if get_node('entities/player').in_place_mode:
		for slot in get_node('UI/TabContainer/Inventory/Grid').get_children():
			if slot.atlas_coords_string == get_node('entities/player').current_placeable_tile_coords:
				slot.activate()
		
func _process(_delta: float) -> void:
	var datetime_dict = Time.get_datetime_dict_from_system()

	var year = datetime_dict["year"]
	var month = datetime_dict["month"]
	var day = datetime_dict["day"]
	var hour = datetime_dict["hour"]
	var minute = datetime_dict["minute"]
	var second = datetime_dict["second"]

	# Example: DD-MM-YYYY HH:MM:SS format
	var custom_datetime_string = "%02d-%02d-%04d %02d:%02d:%02d" % [day, month, year, hour, minute, second]
	get_node('UI/datetime').text = custom_datetime_string

# The function that will intercept all print calls
func gprint(message: String) -> void:
	# Get the current time for logging
	var time_stamp = Time.get_time_string_from_system()

	# Handle regular prints (print(), push_warning())
	var formatted_message = "[LOG] [%s] %s" % [time_stamp, message]
	get_node('UI/PanelContainer/chatbox').text += '\n' + formatted_message 
	# Add your custom logic here, e.g.,
	# log_to_file(formatted_message)
	# display_in_custom_console(formatted_message, Color.WHITE)

# Important: If you call print() or push_error() inside this function, 
# it will NOT recursively call the handler. It will output normally.
	print(message)


func _on_button_pressed() -> void:
	get_tree().quit()

func _on_button_2_pressed() -> void:
	get_node('world/GaeaGenerator').generate()
