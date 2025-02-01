extends Node
## Docstring

#region Signals
#endregion Signals

#region Enums
## TODO
enum AudioBus {
	MASTER,
	SFX,
	MUSIC,
	DIALOGUE,
}
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _buses_dictionary : Dictionary = {
	AudioBus.MASTER: {
		"index":         -1,
		"name":    "Master",
	},
	AudioBus.SFX: {
		"index":         -1,
		"name":       "SFX",
	},
	AudioBus.MUSIC: {
		"index":         -1,
		"name":     "Music",
	},
	AudioBus.DIALOGUE: {
		"index":         -1,
		"name":  "Dialogue",
	},
}
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	for bus in _buses_dictionary.keys():
		_buses_dictionary[bus].index = AudioServer.get_bus_index(_buses_dictionary[bus].name)
	
	_assert_buses_availability()
#endregion Built-in Virtual Methods

#region Public Methods
## TODO
func get_buses() -> Array[AudioBus]:
	return _buses_dictionary.keys()
## TODO
func get_bus_name(bus : AudioBus) -> String:
	return _buses_dictionary[bus].name
## TODO
func get_bus_volume(bus : AudioBus) -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(_buses_dictionary[bus].index))
## TODO
func get_bus_mute_state(bus : AudioBus) -> bool:
	return AudioServer.is_bus_mute(_buses_dictionary[bus].index)
## TODO
func set_bus_volume(bus : AudioBus, volume_factor : float) -> void:
	volume_factor = clampf(volume_factor, 0.0, 1.0)
	AudioServer.set_bus_volume_db(_buses_dictionary[bus].index, linear_to_db(volume_factor))
## TODO
func increase_bus_volume(bus : AudioBus, delta_volume_factor : float) -> void:
	set_bus_volume(bus, get_bus_volume(bus) + delta_volume_factor)
## TODO
func decrease_bus_volume(bus : AudioBus, delta_volume_factor : float) -> void:
	increase_bus_volume(bus, -delta_volume_factor)
## TODO
func set_bus_mute_state(bus : AudioBus, value : bool) -> void:
	AudioServer.set_bus_mute(_buses_dictionary[bus].index, value)
## TODO
func toggle_bus_mute_state(bus : AudioBus) -> void:
	set_bus_mute_state(bus, not get_bus_mute_state(bus))
#endregion Public Methods

#region Private Methods
func _assert_buses_availability() -> void:
	for bus in _buses_dictionary.keys():
		assert(_buses_dictionary[bus].index != -1)
#endregion Private Methods
