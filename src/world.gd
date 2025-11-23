extends Node2D

@onready var main_game_node = get_tree().get_root().get_node('Main')

## Exported variables for easy setup in the Inspector
@export var real_seconds_per_game_hour: float = 60 # How many real seconds equal 1 game hour (e.g., 2.5 seconds * 24 hours = 60s total cycle)

# Day/Night Color Keyframes (Color at a specific in-game hour, 0-23)
# These colors define what the CanvasModulate color should be at that hour.
var color_keyframes: Dictionary = {
	# 6:00 AM (Sunrise/Dawn)
	6: Color(1.0, 0.85, 0.7, 1.0), # Light Orange/Pink tint
	# 9:00 AM (Full Day)
	9: Color.WHITE,
	# 17:00 (5 PM - Afternoon)
	17: Color.WHITE, 
	# 18:00 (6 PM - Sunset/Dusk)
	18: Color(1.0, 0.6, 0.4, 1.0), # Deeper Orange
	# 20:00 (8 PM - Night Begins)
	20: Color(0.1, 0.1, 0.3, 1.0), # Dark Blue
	# 23:00 (11 PM - Deep Night)
	23: Color(0.05, 0.05, 0.15, 1.0), # Very Dark Blue
	# 0:00 (Midnight - Loop point)
	0: Color(0.05, 0.05, 0.15, 1.0), # Stays very dark
	# 4:00 (Pre-Dawn)
	4: Color(0.1, 0.1, 0.3, 1.0), # Starting to lighten a bit
}

# Node Reference
@onready var canvas_modulate: CanvasModulate = $CanvasModulate

# Internal variables
var time_of_day: float = 6.0 # Start the day at 6:00 AM
var speed_multiplier: float = 1.0 / real_seconds_per_game_hour

func float_to_hh_mm(hour_float: float) -> String:
	# 1. Ensure the float is within a 24-hour cycle (0.0 to < 24.0)
	var normalized_hour: float = fmod(hour_float, 24.0)
	
	# 2. Extract the integer part as the hour (H)
	var hour: int = int(floor(normalized_hour))
	
	# 3. Extract the fractional part and convert to minutes (M)
	var minutes_float: float = normalized_hour - hour
	var minute: int = int(round(minutes_float * 60.0))
	
	# Handle potential rounding overflow (e.g., 59.99 minutes rounding to 60)
	if minute >= 60:
		minute -= 60
		hour += 1
		# Re-normalize hour if it crossed 24 due to minute overflow
		hour = int(fmod(float(hour), 24.0)) 
	
	# 4. Format the output string as HH:MM with leading zeros
	var result: String = "%02d:%02d" % [hour, minute]
	
	return result

func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# TODO: use gaia to regenerate the map again if needed
	#$GaeaGenerator.generate()
	
	# Set initial color based on the starting hour
	canvas_modulate.color = _get_interpolated_color(time_of_day)
	print("Cycle started at hour: %s" % int(time_of_day))
	
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
					# can also potentially spawn player here
					var local_position = get_node('map').map_to_local(cell_coords)
					valid_player_spawn_coords.append(to_global(local_position))
						
	# move the player to an appopriate spawn point
	main_game_node.get_node('entities/player').position = valid_player_spawn_coords.pick_random()
	
func _process(delta):
	# 1. Update the time
	time_of_day += delta * speed_multiplier
	
	# Wrap the time around 24 hours (0 to 24)
	if time_of_day >= 24.0:
		time_of_day = fmod(time_of_day, 24.0) # Reset time, keeping the remainder
		print("--- New Day Starts! ---")
	
	# 2. Get the target color for the current time
	var target_color: Color = _get_interpolated_color(time_of_day)
	
	# 3. Apply the color smoothly
	canvas_modulate.color = canvas_modulate.color.lerp(target_color, 0.05)
	
	# Optional: Display the current hour for debugging
	# print("Current Hour: %s" % str(int(time_of_day)).pad_zeros(2))
	
	# Display the current time in the editor (helpful for quick checks)
	#if Engine.is_editor_hint() or OS.is_debug_build():
	#	set_meta("Current Time", "%s:00" % str(int(time_of_day)).pad_zeros(2))

# Helper function to find the color based on the time_of_day
func _get_interpolated_color(time: float) -> Color:
	# 1. Find the previous and next keyframe hours
	var prev_hour: int = -1
	var next_hour: int = -1
	
	# The keyframes dictionary keys are the hours (0-23)
	var hours: Array = color_keyframes.keys()
	hours.sort() # Ensure they are in order (e.g., 4, 6, 9, 17...)

	# Loop to find the hours surrounding the current time
	for i in range(hours.size()):
		var current_h = hours[i]
		
		# This handles the wrap-around from Hour 23 back to Hour 0
		if current_h > time:
			next_hour = current_h
			# The previous hour is the one before the current index
			prev_hour = hours[i - 1] if i > 0 else hours.back() # If 0 is next, 23 is previous
			break
	
	# If we didn't break, it means the time is after the last keyframe (e.g., 23:30)
	# The transition is from the last hour (23) to the first hour (0)
	if next_hour == -1:
		prev_hour = hours.back()
		next_hour = hours.front()
		
	# 2. Get the colors for the keyframes
	var prev_color: Color = color_keyframes[prev_hour]
	var next_color: Color = color_keyframes[next_hour]
	
	# 3. Calculate the percentage (t) between the previous and next hour
	var total_time_span: float
	if next_hour > prev_hour:
		total_time_span = float(next_hour - prev_hour)
	else:
		# Handling the wrap-around (e.g., 23 to 6 is a 7 hour span)
		total_time_span = 24.0 - float(prev_hour) + float(next_hour)
		
	var time_since_prev: float
	if time >= prev_hour:
		time_since_prev = time - prev_hour
	else:
		# Handling the time *after* 23:00 and *before* 06:00
		time_since_prev = 24.0 - prev_hour + time
		
	var t: float = time_since_prev / total_time_span
	
	# 4. Interpolate and return the final color
	return prev_color.lerp(next_color, t)
