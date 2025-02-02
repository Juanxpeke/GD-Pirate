@tool
class_name TaskBarApp
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
@export var title : String = "App Title":
	set(new_title):
		title = new_title
		if is_inside_tree():
			_update_title()
## TODO
@export var icon : Texture2D = null:
	set(new_icon):
		icon = new_icon
		if is_inside_tree():
			_update_icon()
## TODO
@export var window_app : WindowApp = null:
	set(new_window_app):
		assert(window_app == null)
		window_app = new_window_app
		if is_inside_tree():
			_update_window_app()
## TODO
@export var inactive_style_box : StyleBox
## TODO
@export var active_style_box : StyleBox
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var _app_icon  : TextureRect = %Icon
@onready var _app_title : Label       = %Title
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	assert(inactive_style_box)
	assert(active_style_box)
	
	_update_title()
	_update_icon()
	_update_window_app()

func _gui_input(event : InputEvent) -> void:
	if event.is_action_pressed("left_click") and window_app:
		if WindowApp.active_window_app == window_app:
			window_app.minimize()
		else:
			window_app.open()
#endregion Built-in Virtual Methods

#region Public Methods
## TODO
func update(app : WindowApp) -> void:
	title = app.title
	icon = app.icon
	window_app = app
#endregion Public Methods

#region Private Methods
func _update_title() -> void:
	_app_title.text = title

func _update_icon() -> void:
	if icon:
		_app_icon.texture = icon

func _update_window_app() -> void:
	if window_app:
		window_app.activated.connect(func(): add_theme_stylebox_override("panel", active_style_box))
		window_app.deactivated.connect(func(): add_theme_stylebox_override("panel", inactive_style_box))
		window_app.opened.connect(func(): show())
		window_app.closed.connect(func(): hide())
#endregion Private Methods
