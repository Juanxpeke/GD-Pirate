class_name DialoguePool
extends Resource
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO
@export var dialogues : Array[Dialogue] = []
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
#endregion Built-in Virtual Methods

#region Public Methods
## TODO
func execute() -> void:
	dialogues.pick_random().execute()
#endregion Public Methods

#region Private Methods
#endregion Private Methods
