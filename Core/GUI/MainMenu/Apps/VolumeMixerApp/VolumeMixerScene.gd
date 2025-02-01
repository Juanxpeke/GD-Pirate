extends Control
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
@export var bus_volume_container_scene : PackedScene
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var _buses_arranger : Control = %BusesArranger
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	for bus in AudioManager.AudioBus.values():
		var bus_volume_container : BusVolumeContainer = bus_volume_container_scene.instantiate()
		bus_volume_container.bus = bus
		_buses_arranger.add_child(bus_volume_container)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
