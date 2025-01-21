extends Node2D
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
@export var character : CharacterBody2D = null
@export var hook_impulse_magnitude : float = 800.0
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var ray_cast : RayCast2D = %RayCast
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	assert(character)

func _process(delta : float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and ray_cast.is_colliding():
		var collision_point := ray_cast.get_collision_point()
		
		var impulse_vector := collision_point - character.global_position
		var impulse_direction := impulse_vector.normalized()
		
		character.velocity = impulse_direction * hook_impulse_magnitude
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
