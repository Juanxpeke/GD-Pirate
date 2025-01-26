class_name ScriptedTeleportArea
extends ScriptedArea
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO
@export var target : Marker2D = null
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
	assert(target)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _character_entered() -> void:
	LogManager.systems_log("Character entered teleport area %s" % name)
	character.global_position = target.global_position
	character.velocity = Vector2.ZERO

func _character_exited() -> void:
	LogManager.systems_log("Character exited teleport area %s" % name)
#endregion Private Methods
