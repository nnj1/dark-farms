extends Control

var block_name: String
var quantity: int
var active:bool = false

func prepare(given_block_name: String, given_quantity: int, given_texture: Texture2D):
	self.block_name = given_block_name
	self.quantity = given_quantity
	get_node('icon').texture = given_texture 

func _ready() -> void:
	self.tooltip_text = self.block_name
	get_node('count').text = str(self.quantity)
	
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
		@warning_ignore("standalone_ternary")
		deactivate() if active else activate()

func activate():
	for sibling in get_siblings(self):
		sibling.deactivate()
	$activeborder.visible = true
	$AnimationPlayer.play('bounce')
	UIPlayer.play_button_click()
	active = true
	
func deactivate():
	$activeborder.visible = false
	$AnimationPlayer.stop()
	UIPlayer.play_button_click()
	active = false
	
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
