class_name ScriptedArea
extends Area2D
## Docstring

#region Signals
## TODO
signal character_entered(entering_type : EnteringTypeByOrdering)
#endregion Signals

#region Enums
## TODO
enum EnteringTypeByOrdering {
	## TODO
	NONE,
	## TODO
	RETURN,
	## TODO
	DEFAULT,
	## TODO
	SKIP
}
#endregion Enums

#region Constants
#endregion Constants

#region Static Variables
static var last_scripted_area : ScriptedArea = null
#endregion Static Variables

#region Exports Variables
## TODO
@export var character : DumbFriend = null

@export_group("Ordering")
## TODO
@export var next_area : ScriptedArea = null
## TODO
@export var required_previous_area : ScriptedArea = null
## TODO
@export var force_initial : bool = false

@export_group("Dialogues")
## TODO
@export var enter_dialogue_pool : DialoguePool = null
## TODO
@export var return_dialogue_pool : DialoguePool = null
## TODO
@export var skip_dialogue_pool : DialoguePool = null
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _character_in : bool = false
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Static Methods
#endregion Static Methods

#region Built-in Virtual Methods
func _ready() -> void:
	assert(character)
	assert(monitoring)
	assert(not monitorable)
	
	if force_initial:
		last_scripted_area = self
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Calbacks
func _on_body_entered(body : Node2D) -> void:
	if body is DumbFriend:
		var past_scripted_area := last_scripted_area
		last_scripted_area = self
		
		if required_previous_area == null or (required_previous_area == past_scripted_area):
			_character_in = true
			_character_entered()
			_handle_entering_type(past_scripted_area)
		else:
			LogManager.systems_log("Required previous area is not last area (Not entering %s)" % name)

func _on_body_exited(body : Node2D) -> void:
	if body is DumbFriend:
		if _character_in:
			_character_in = false
			_character_exited()
#endregion Callbacks

func _character_entered() -> void:
	LogManager.systems_log("Character entered area %s" % name)
	
func _character_exited() -> void:
	LogManager.systems_log("Character exited area %s" % name)
	
func _handle_entering_type(past_scripted_area : ScriptedArea) -> void:
	if past_scripted_area != null and past_scripted_area != last_scripted_area:
		if past_scripted_area.next_area == last_scripted_area:
			character_entered.emit(EnteringTypeByOrdering.DEFAULT)
			LogManager.systems_log("DEFAULT case executed to area %s" % name)
			return
		
		var future_area_before_change := past_scripted_area.next_area
		while future_area_before_change != null:
			if future_area_before_change == self:
				character_entered.emit(EnteringTypeByOrdering.SKIP)
				if skip_dialogue_pool:
					skip_dialogue_pool.execute()
				LogManager.systems_log("SKIP case executed to area %s" % name)
				return
			future_area_before_change = future_area_before_change.next_area
		
		var future_area_after_change := self.next_area
		while future_area_after_change != null:
			if future_area_after_change == past_scripted_area:
				character_entered.emit(EnteringTypeByOrdering.RETURN)
				if return_dialogue_pool:
					return_dialogue_pool.execute()
				LogManager.systems_log("RETURN case executed to area %s" % name)
				return
			future_area_after_change = future_area_after_change.next_area
		
		character_entered.emit(EnteringTypeByOrdering.NONE)
		if enter_dialogue_pool:
			enter_dialogue_pool.execute()
#endregion Private Methods

#region Inner Classes
#endregion Inner Classes
