extends Control

var block_name: String
var quantity: int

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


func _on_mouse_exited() -> void:
	if get_node('border').visible:
		get_node('border').visible = false
