extends TabContainer

func _ready():
	# Connect the "tab_changed" signal to a function
	# The signal is emitted when the user switches tabs
	connect("tab_changed", Callable(self, "_on_tab_changed"))
	# Initial size update for the first tab
	_on_tab_changed(current_tab)

@warning_ignore("unused_parameter")
func _on_tab_changed(tab_idx):
	# Get the control node for the current tab
	var current_control = get_current_tab_control()
	if current_control:
		# Get the combined minimum size required by the child and its contents
		var min_size = current_control.get_combined_minimum_size()
		
		# Set the TabContainer's custom minimum size to match the child's minimum size
		# Add any necessary padding for tabs/margins if required
		# For simplicity, this example just uses the child's minimum size
		custom_minimum_size = min_size
		
		# Note: You might need to add extra height for the tab bar itself, 
		# which can be retrieved using get_tab_bar().size.y
		# Example: custom_minimum_size.y = min_size.y + get_tab_bar().size.y 
