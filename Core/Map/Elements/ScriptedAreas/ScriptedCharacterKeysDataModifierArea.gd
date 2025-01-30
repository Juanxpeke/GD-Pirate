class_name ScriptedCharacterKeysDataModifierArea
extends ScriptedArea
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
@export var new_character_keys_data : Dictionary = DumbFriend.DEFAULT_CHARACTER_KEYS_DATA
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
	LogManager.systems_log("Character entered key data modifier area %s" % name)
	character.character_keys_data = new_character_keys_data

func _character_exited() -> void:
	LogManager.systems_log("Character exited key data modifier area %s" % name)
#endregion Private Methods
