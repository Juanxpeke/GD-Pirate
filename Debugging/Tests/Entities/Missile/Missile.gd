class_name Missile
extends CharacterBody2D
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## TODO
const MOVEMENT_SPEED : float = 1080.0
## TODO
const ROTATION_SPEED : float = deg_to_rad(480.0)
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		rotate(-ROTATION_SPEED * delta)
	if Input.is_action_pressed("move_right"):
		rotate(ROTATION_SPEED * delta)
	
	var local_up_vector = global_transform.basis_xform(Vector2.UP)
	velocity = local_up_vector * MOVEMENT_SPEED
	
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		_explode()
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _explode() -> void:
	queue_free()
#endregion Private Methods
