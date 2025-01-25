class_name ScriptedMovementArea
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
static var current_scripted_movement_area : ScriptedMovementArea = null
#endregion Static Variables

#region Exports Variables
## TODO
@export var character   : CharacterBody2D = null
## TODO
@export var destination : Marker2D = null

@export_group("Ordering")
## TODO
@export var next_area : ScriptedMovementArea = null
## TODO
@export var is_initial : bool = false

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
	assert(destination)
	assert(monitoring)
	assert(not monitorable)
	
	if is_initial:
		current_scripted_movement_area = self
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta : float) -> void:
	pass
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _on_body_entered(body : Node2D) -> void:
	if body is DumbFriend:
		if current_scripted_movement_area != self:
			var past_scripted_movement_area := current_scripted_movement_area
			current_scripted_movement_area = self
			
			if past_scripted_movement_area.next_area == current_scripted_movement_area:
				character_entered.emit(EnteringTypeByOrdering.DEFAULT)
				return
			
			var future_area_before_change := past_scripted_movement_area.next_area
			while future_area_before_change != null:
				if future_area_before_change == self:
					character_entered.emit(EnteringTypeByOrdering.SKIP)
					skip_dialogue_pool.execute()
					return
				future_area_before_change = future_area_before_change.next_area
			
			var future_area_after_change := self.next_area
			while future_area_after_change != null:
				if future_area_after_change == past_scripted_movement_area:
					character_entered.emit(EnteringTypeByOrdering.RETURN)
					return_dialogue_pool.execute()
					return
				future_area_after_change = future_area_after_change.next_area

func _on_body_exited(body : Node2D) -> void:
	if body is DumbFriend:
		pass
#endregion Private Methods

#region Inner Classes
#endregion Inner Classes
