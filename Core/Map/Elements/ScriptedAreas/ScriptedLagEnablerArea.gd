class_name ScriptedLagEnablerArea
extends ScriptedArea
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
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	super()
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _character_entered() -> void:
	LogManager.systems_log("Character entered lag enabler area %s" % name)
	character.enable_lag_teleporter()

func _character_exited() -> void:
	LogManager.systems_log("Character exited lag enabler area %s" % name)
#endregion Private Methods
