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
## TODO
@export var one_shot : bool = false

@export_group("Ordering")
## TODO
@export var next_area : ScriptedArea = null
## TODO
@export var required_previous_area : ScriptedArea = null
## TODO
@export var force_initial : bool = false

@export_group("Dialogues")
## TODO
@export var return_dialogue_pool : DialoguePool = null
## TODO
@export var skip_dialogue_pool : DialoguePool = null
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
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
			_character_entered()
			if one_shot:
				last_scripted_area = past_scripted_area
				queue_free()
		else:
			""
		
		if past_scripted_area != null and past_scripted_area != last_scripted_area:
			if past_scripted_area.next_area == last_scripted_area:
				character_entered.emit(EnteringTypeByOrdering.DEFAULT)
				return
			
			var future_area_before_change := past_scripted_area.next_area
			while future_area_before_change != null:
				if future_area_before_change == self:
					character_entered.emit(EnteringTypeByOrdering.SKIP)
					if skip_dialogue_pool:
						skip_dialogue_pool.execute()
					return
				future_area_before_change = future_area_before_change.next_area
			
			var future_area_after_change := self.next_area
			while future_area_after_change != null:
				if future_area_after_change == past_scripted_area:
					character_entered.emit(EnteringTypeByOrdering.RETURN)
					if return_dialogue_pool:
						return_dialogue_pool.execute()
					return
				future_area_after_change = future_area_after_change.next_area

func _on_body_exited(body : Node2D) -> void:
	if body is DumbFriend:
		character.behaviour_mode = DumbFriend.BehaviourMode.NONE
#endregion Callbacks

func _character_entered() -> void:
	pass
#endregion Private Methods

#region Inner Classes
#endregion Inner Classes
