class_name PeskyApp
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
var _call_time_minute : int = 0
var _call_time_second : int = 0
#endregion Private Variables

#region On Ready Variables
@onready var _call_time_label : Label = %CallTimeLabel
@onready var _call_timer      : Timer = %CallTimer
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_update_call_time_label()
	
	_call_timer.timeout.connect(_on_call_timer_timeout)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _on_call_timer_timeout() -> void:
	_update_call_time_label()

func _update_call_time_label() -> void:
	_call_time_second += 1
	
	if _call_time_second >= 60:
		_call_time_minute = _call_time_minute + 1
		_call_time_second = 0
		
	_call_time_label.text = "%02d:%02d" % [_call_time_minute, _call_time_second]
#endregion Private Methods
