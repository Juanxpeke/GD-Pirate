class_name ScriptedStompArea
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
@export var free_on_stomp : bool = true
## TODO
@export var keep_stomping : bool = true
## TODO
@export var deactivate_required_previous_area_until_stomp : bool = true
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
	character.stomped_tile.connect(_on_stomped_tile)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _on_stomped_tile() -> void:
	if deactivate_required_previous_area_until_stomp:
		required_previous_area.monitoring = true
	if last_scripted_area == self and free_on_stomp:
		last_scripted_area = null
		queue_free()

func _character_entered() -> void:
	LogManager.systems_log("Character entered stomp area %s" % name)
	character.behaviour_mode = DumbFriend.BehaviourMode.STOMP
	
	if deactivate_required_previous_area_until_stomp and required_previous_area:
		required_previous_area.monitoring = false

func _character_exited() -> void:
	if not keep_stomping:
		LogManager.systems_log("Character exited stomp area %s" % name)
		character.behaviour_mode = DumbFriend.BehaviourMode.NONE
	else:
		LogManager.systems_log("Character exited stomp area %s, but still stomping" % name)
#endregion Private Methods
