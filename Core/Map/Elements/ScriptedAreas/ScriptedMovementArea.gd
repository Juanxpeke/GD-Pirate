class_name ScriptedMovementArea
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
	character.behaviour_mode = DumbFriend.BehaviourMode.FOLLOWING_TARGET
	character.follow_target = target.global_position
#endregion Private Methods
