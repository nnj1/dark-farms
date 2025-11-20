extends Control

var block_name: String

func prepare(given_block_name: String = 'default_block'):
	self.block_name = given_block_name
	

func _ready() -> void:
	self.tooltip_text = block_name
	#TODO: set icons properly
	get_node('icon').texture.region = Rect2(12 * randi_range(0,100), 12 * randi_range(0,100), 12, 12)
