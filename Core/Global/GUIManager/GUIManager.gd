extends Node
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	for node in get_tree().get_nodes_in_group("OnHoverDarkenControl"):
		print(node.name)
		assert(node is Control)
		var control_node : Control = node
		control_node.mouse_entered.connect(func():
			control_node.modulate = Color(0.8, 0.8, 0.8))
		control_node.mouse_exited.connect(func():
			control_node.modulate = Color(1.0, 1.0, 1.0))
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
