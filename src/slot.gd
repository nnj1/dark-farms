extends Control

@onready var main_game_node = get_tree().get_root().get_node('Main')

var block_name: String
var quantity: int
var active:bool = false
var atlas_coords_string: String

func prepare(given_block_name: String, given_quantity: int, given_texture: Texture2D, given_atlas_coords_string: String):
	self.block_name = given_block_name
	self.quantity = given_quantity
	self.atlas_coords_string = given_atlas_coords_string
	get_node('icon').texture = given_texture 
	get_node('Panel/VBoxContainer/HBoxContainer/icon').texture = given_texture 

func _ready() -> void:
	self.tooltip_text = self.block_name
	get_node('Panel/VBoxContainer/HBoxContainer/Label').text = self.block_name
	get_node('count').text = str(self.quantity)
	$Panel.visible = false
	
func _process(_delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	if not get_node('border').visible:
		get_node('border').visible = true
		UIPlayer.play_button_hover()

func _on_mouse_exited() -> void:
	if get_node('border').visible:
		get_node('border').visible = false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed == false:
		if GlobalVars.BLOCK_DEFINITIONS[self.atlas_coords_string].placeable:	
			@warning_ignore("standalone_ternary")
			deactivate() if active else activate()
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed == false:
		# close the panels of all the other siblings
		for sibling in get_siblings(self):
			sibling.get_node('Panel').visible = false 
		$Panel.visible = !$Panel.visible

	
func activate():
	for sibling in get_siblings(self):
		sibling.deactivate()
	$activeborder.visible = true
	$AnimationPlayer.play('bounce')
	UIPlayer.play_button_click()
	active = true
	main_game_node.get_node('entities/player').in_place_mode = true
	main_game_node.get_node('entities/player').current_placeable_tile_coords = self.atlas_coords_string
	
func deactivate():
	$activeborder.visible = false
	$AnimationPlayer.stop()
	UIPlayer.play_button_click()
	active = false
	main_game_node.get_node('entities/player').in_place_mode = false
	main_game_node.get_node('entities/player').current_placeable_tile_coords = null
	
func get_siblings(node):
	# Check if the node has a parent
	if not node.get_parent():
		return [] # Return an empty array if it's the root node

	# Get the array of all children from the parent
	var parent_children: Array[Node] = node.get_parent().get_children()
	var siblings: Array[Node] = []

	# Iterate through the children and add those that are not the current node
	for child in parent_children:
		if child != node:
			siblings.append(child)

	return siblings


func _on_button_pressed() -> void:
	# drop the item
	# first delete it
	main_game_node.get_node('entities/player').delete_block_from_inventory(self.atlas_coords_string)
	# TODO: then spawn it on the ground
	
	$Panel.visible = false # Replace with function body.

func _on_button_2_pressed() -> void:
	# destory the item
	main_game_node.get_node('entities/player').delete_block_from_inventory(self.atlas_coords_string)
	$Panel.visible = false # Replace with function body.

func _on_button_3_pressed() -> void:
	$Panel.visible = false
