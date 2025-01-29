class_name MainMenu
extends Control
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO
@export var desktop_app_scene : PackedScene
## TODO
@export var window_app_scene : PackedScene
## TODO
@export var task_bar_app_scene : PackedScene
## TODO
@export var apps : Array[MainMenuApp] = []
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _time_hour   : int = 19
var _time_minute : int = 50
#endregion Private Variables

#region On Ready Variables
@onready var _desktop_apps_container  := %DesktopAppsContainer
@onready var _window_apps_container   := %WindowAppsContainer
@onready var _task_bar_apps_container := %TaskBarAppsContainer
@onready var _start_menu              := %StartMenu
@onready var _start_button            := %StartButton
@onready var _off_button              := %OffButton
@onready var _time_label              := %TimeLabel
@onready var _time_timer              := %TimeTimer
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_assert_time_parameters()
	_setup_apps()
	_update_time_label()
	
	_start_menu.hide()
	
	_start_button.gui_input.connect(_on_start_button_gui_input)
	_off_button.pressed.connect(_on_off_button_pressed)
	_time_timer.timeout.connect(_on_time_timer_timeout)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Assertions
func _assert_time_parameters() -> void:
	assert(not _time_timer.one_shot)
#endregion Assertions
#region Callbacks
func _on_start_button_gui_input(event : InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		if _start_menu.visible:
			_start_menu.hide()
		else:
			_start_menu.show()

func _on_off_button_pressed() -> void:
	if ConfigurationManager.get_operative_system() == ConfigurationManager.OperativeSystem.WEB:
		LogManager.systems_log("Can't quit from web version")
	else:
		get_tree().quit()

func _on_time_timer_timeout() -> void:
	_update_time_label()
#endregion Callbacks
func _setup_apps() -> void:
	for app : MainMenuApp in apps:
		var window_app : WindowApp = window_app_scene.instantiate()
		window_app.update(app)
		window_app.hide()
		_window_apps_container.add_child(window_app)
		
		var move_front = func(): _window_apps_container.move_child(window_app, -1)
		window_app.opened.connect(move_front)
		window_app.left_clicked.connect(move_front)
		
		var desktop_app : DesktopApp = desktop_app_scene.instantiate()
		desktop_app.update(window_app)
		_desktop_apps_container.add_child(desktop_app)
		
		var task_bar_app : TaskBarApp = task_bar_app_scene.instantiate()
		task_bar_app.update(window_app)
		task_bar_app.hide()
		_task_bar_apps_container.add_child(task_bar_app)

func _update_time_label() -> void:
	_time_minute += 1
	
	if _time_minute >= 60:
		_time_hour   = (_time_hour + 1) % 24
		_time_minute = 0
	
	var hour  := _time_hour
	var am_pm := "AM"
	if _time_hour >= 12:
		am_pm = "PM"
	if _time_hour > 12:
		hour -= 12
	elif _time_hour == 0:
		hour = 12
		
	_time_label.text = "%02d:%02d %s" % [hour, _time_minute, am_pm]
#endregion Private Methods
