class_name DialoguePool
extends Dialogue
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO
@export var dialogues : Array[DialogueSingle] = []
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
func get_text() -> String:
	var random_dialogue_single : DialogueSingle = dialogues.pick_random()
	if random_dialogue_single:
		return random_dialogue_single.get_text()
	else:
		return ""
#endregion Public Methods

#region Private Methods
#endregion Private Methods
