extends Node2D

# Load the cursor texture at the beginning
const ORIGINAL_CURSOR_TEXTURE_PATH: String = "res://assets/Megabyte Games Mouse Cursor Pack-2022-3-27/Megabyte Games Mouse Cursor Pack/16x16/png/cursor-pointer-18.png"
const SCALE_FACTOR: float = 1.5 # Make it twice as big

# Set the hotspot (the active click point) of the cursor.
# If your image is 64x64, a hotspot of (32, 32) centers the click point.
# For an arrow cursor, (0, 0) is usually best.
const CURSOR_HOTSPOT: Vector2 = Vector2(0, 0) 

func _ready() -> void:
		
	var original_texture = load(ORIGINAL_CURSOR_TEXTURE_PATH)

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
