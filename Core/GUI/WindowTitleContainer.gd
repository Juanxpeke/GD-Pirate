@tool
class_name WindowTitleContainer
extends PanelContainer
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO
@export var title : String = "Title":
	set(new_title):
		title = new_title
		if is_inside_tree():
			_window_title.text = title
## TODO
@export var icon : Texture2D = null:
	set(new_icon):
		icon = new_icon
		if is_inside_tree() and icon:
			_window_icon.texture = icon
## TODO
@export var window : Control = null
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var _window_icon  : TextureRect = %WindowIcon
@onready var _window_title : Label       = %WindowTitle
@onready var _close_button : Button      = %CloseButton
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_window_title.text = title
	
	if icon:
		_window_icon.texture = icon
	
	if window:
		_close_button.pressed.connect(func(): window.hide())
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
