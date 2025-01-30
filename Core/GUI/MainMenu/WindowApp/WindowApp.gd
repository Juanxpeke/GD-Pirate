@tool
class_name WindowApp
extends Control
## Docstring

#region Signals
## TODO
signal opened
## TODO
signal closed
## TODO
signal minimized
## TODO
signal left_clicked
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Static Variables
## TODO
static var active_window_app : WindowApp = null
#endregion Static Variables

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
@export var content_scene : PackedScene = null:
	set(new_content_scene):
		assert(content_scene == null)
		content_scene = new_content_scene
		if is_inside_tree():
			_update_content()
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _holding : bool = false
var _mouse_vector_at_hold : Vector2
#endregion Private Variables

#region On Ready Variables
@onready var _header_container  : PanelContainer = %HeaderContainer
@onready var _header_icon       : TextureRect    = %HeaderIcon
@onready var _header_title      : Label          = %HeaderTitle
@onready var _minimize_button   : Button         = %MinimizeButton
@onready var _close_button      : Button         = %CloseButton
@onready var _content_container : PanelContainer = %ContentContainer
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_update_title()
	_update_icon()
	_update_content()
	
	_header_container.gui_input.connect(_on_header_gui_input)
	_minimize_button.pressed.connect(func(): minimize())
	_close_button.pressed.connect(func(): close())

func _process(_delta : float) -> void:
	if _holding:
		var mouse_position := get_viewport().get_mouse_position()
		if get_viewport_rect().has_point(mouse_position):
			position = mouse_position - _mouse_vector_at_hold
		else:
			_holding = false

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("exit") and active_window_app == self:
		minimize()

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		active_window_app = self
		left_clicked.emit()
#endregion Built-in Virtual Methods

#region Public Methods
## TODO
func update(app : MainMenuApp) -> void:
	title = app.name
	icon = app.icon
	content_scene = app.content_scene
## TODO
func open() -> void:
	active_window_app = self
	
	_content_container.process_mode = Node.PROCESS_MODE_INHERIT
	
	show()
	opened.emit()
## TODO
func close() -> void:
	assert(active_window_app == self)
	active_window_app = null
	
	_content_container.process_mode = Node.PROCESS_MODE_DISABLED
	
	hide()
	closed.emit()
## TODO
func minimize() -> void:
	assert(active_window_app == self)
	active_window_app = null
	
	_content_container.process_mode = Node.PROCESS_MODE_DISABLED
	
	hide()
	minimized.emit()
#endregion Public Methods

#region Private Methods
func _on_header_gui_input(event : InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		_holding = true
		_mouse_vector_at_hold = get_viewport().get_mouse_position() - position
	elif event.is_action_released("left_click"):
		_holding = false

func _update_title() -> void:
	_header_title.text = title

func _update_icon() -> void:
	if icon:
		_header_icon.texture = icon

func _update_content() -> void:
	if content_scene:
		var content : Control = content_scene.instantiate()
		_content_container.add_child(content)
#endregion Private Methods
