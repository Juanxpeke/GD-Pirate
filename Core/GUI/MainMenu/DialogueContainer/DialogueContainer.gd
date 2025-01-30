class_name DialogueContainer
extends Control
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## TODO
const DEFAULT_DIALOGUE_SCREEN_TIME : float = 2.4
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _dialogue_screen_time : float = 0.0
#endregion Private Variables

#region On Ready Variables
@onready var _dialogue_label : RichTextLabel = %DialogueLabel
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	hide()

func _process(delta : float) -> void:
	_dialogue_screen_time = max(_dialogue_screen_time - delta, 0.0)
	
	if _dialogue_screen_time == 0.0:
		hide()
#endregion Built-in Virtual Methods

#region Public Methods
func show_text(text : String) -> void:
	_dialogue_label.text = "Timmy: " + text
	_dialogue_screen_time = DEFAULT_DIALOGUE_SCREEN_TIME
	
	show()
#endregion Public Methods

#region Private Methods
#endregion Private Methods
