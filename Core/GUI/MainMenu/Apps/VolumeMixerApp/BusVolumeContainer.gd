class_name BusVolumeContainer
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
var bus : AudioManager.AudioBus:
	set(new_bus):
		bus = new_bus
		print("%s bus setted to %s" % [name, new_bus])
		if is_inside_tree():
			_update_bus_information()
#endregion Public Variables

#region Private Variables
var _first_time_updated : bool = true
var _volume_value_changed_callable : Callable
var _mute_toggled_callable : Callable
#endregion Private Variables

#region On Ready Variables
@onready var _bus_name          : Label      = %BusName
@onready var _bus_volume_slider : Slider     = %BusVolumeSlider
@onready var _bus_mute_button   : BaseButton = %BusMuteButton
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_assert_slider_parameters()
	_update_bus_information()
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _assert_slider_parameters() -> void:
	assert(_bus_volume_slider.min_value == 0.0)
	assert(_bus_volume_slider.max_value == 1.0)
	assert(_bus_volume_slider.step      == 0.1)

func _update_bus_information() -> void:
	var bus_value := bus
	# Name
	_bus_name.text = AudioManager.get_bus_name(bus)
	# Slider
	_bus_volume_slider.value = AudioManager.get_bus_volume(bus)
	if not _first_time_updated:
		_bus_volume_slider.value_changed.disconnect(_volume_value_changed_callable)
	_volume_value_changed_callable = func(value): AudioManager.set_bus_volume(bus_value, value)
	_bus_volume_slider.value_changed.connect(_volume_value_changed_callable)
	# Button
	_bus_mute_button.button_pressed = AudioManager.get_bus_mute_state(bus)
	if not _first_time_updated:
		_bus_mute_button.toggled.disconnect(_mute_toggled_callable)
	_mute_toggled_callable = func(toggle_on): AudioManager.set_bus_mute_state(bus_value, toggle_on)
	_bus_mute_button.toggled.connect(_mute_toggled_callable)
	
	if _first_time_updated:
		_first_time_updated = false
#endregion Private Methods
