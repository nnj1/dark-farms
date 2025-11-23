extends Node2D

func _ready() -> void:
	GlobalVars.change_cursor()
	
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
	
	# throw on FPS and other shit
	get_node('UI/datetime').text = custom_datetime_string + " | FPS: " + str(Engine.get_frames_per_second()) + ' | In-game Time: ' + str(get_node('world').float_to_hh_mm(get_node('world').time_of_day))

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

func _on_h_slider_value_changed(value: float) -> void:
	var sfx_index= AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(sfx_index, value)

func _on_h_slider2_value_changed(value: float) -> void:
	var sfx_index= AudioServer.get_bus_index("Sounds")
	AudioServer.set_bus_volume_db(sfx_index, value)

func _on_button_3_pressed() -> void:
	get_node('world').time_of_day += 1
