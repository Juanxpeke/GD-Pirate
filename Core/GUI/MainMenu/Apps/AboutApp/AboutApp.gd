class_name AboutApp
extends Control
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
var _current_page_index : int = 0
#endregion Private Variables

#region On Ready Variables
@onready var _title                : Label   = %Title
@onready var _previous_page_button : Button  = %PreviousPageButton
@onready var _next_page_button     : Button  = %NextPageButton
@onready var _pages_container      : Control = %PagesContainer
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	for page_index in range(_pages_container.get_child_count()):
		_hide_page(page_index)
	_show_page(_current_page_index)
	
	_previous_page_button.pressed.connect(_on_previous_page_button_pressed)
	_next_page_button.pressed.connect(_on_next_page_button_pressed)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_previous_page_button_pressed() -> void:
	_hide_page(_current_page_index)
	_current_page_index = (_current_page_index - 1) % _pages_container.get_child_count()
	_show_page(_current_page_index)

func _on_next_page_button_pressed() -> void:
	_hide_page(_current_page_index)
	_current_page_index = (_current_page_index + 1) % _pages_container.get_child_count()
	_show_page(_current_page_index)
#endregion Callbacks
func _hide_page(page_index : int) -> void:
	_pages_container.get_child(page_index).hide()

func _show_page(page_index : int) -> void:
	_pages_container.get_child(page_index).show()
	_title.text = _pages_container.get_child(page_index).name
#endregion Private Methods
