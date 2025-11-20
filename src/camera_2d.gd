extends Camera2D

## --- Configuration ---
@export var zoom_speed: float = 8.0 # How quickly the camera zooms in/out (higher = faster)
@export var min_zoom: Vector2 = Vector2(0.5, 0.5) # Max zoom-in level
@export var max_zoom: Vector2 = Vector2(2.0, 2.0) # Max zoom-out level
@export var zoom_step: float = 0.2 # How much the zoom changes per scroll wheel tick

## --- State ---
var target_zoom: Vector2 = Vector2(1.0, 1.0) # The target zoom level the camera is moving towards

func _ready():
	# Initialize the target zoom to the current zoom level
	target_zoom = zoom

func _unhandled_input(event: InputEvent) -> void:
	# Check for mouse wheel input
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			# Zoom in (decrease zoom value)
			target_zoom -= Vector2(zoom_step, zoom_step)
			# Clamp the target zoom to the minimum allowed value
			target_zoom = target_zoom.max(min_zoom)
			
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			# Zoom out (increase zoom value)
			target_zoom += Vector2(zoom_step, zoom_step)
			# Clamp the target zoom to the maximum allowed value
			target_zoom = target_zoom.min(max_zoom)

func _process(delta: float) -> void:
	# Use 'lerp' (Linear Interpolation) to smoothly move the current 'zoom'
	# towards the 'target_zoom' every frame.
	# The 'zoom_speed * delta' controls the smoothness and speed.
	zoom = zoom.lerp(target_zoom, zoom_speed * delta)
	
	# Optional: Stop processing if the zoom is very close to the target
	# if zoom.is_equal_approx(target_zoom):
	#     set_process(false)
