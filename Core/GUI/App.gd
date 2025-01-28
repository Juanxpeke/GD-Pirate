@tool
class_name App
extends VBoxContainer
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO
@export var title : String = "App Title":
	set(new_title):
		title = new_title
		if is_inside_tree():
			_app_title.text = title
## TODO
@export var icon : Texture2D = null:
	set(new_icon):
		icon = new_icon
		if is_inside_tree() and icon:
			_app_icon.texture = icon
## TODO
@export var window : Control = null
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _mouse_in : bool = false
#endregion Private Variables

#region On Ready Variables
@onready var _app_icon  : TextureRect = %AppIcon
@onready var _app_title : Label       = %AppName
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_app_title.text = title
	
	if icon:
		_app_icon.texture = icon
		
	mouse_entered.connect(func(): _mouse_in = true)
	mouse_exited.connect(func(): _mouse_in = false)

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("left_click") and _mouse_in and window:
		window.show()
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
