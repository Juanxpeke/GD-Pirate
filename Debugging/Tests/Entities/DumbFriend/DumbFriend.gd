class_name DumbFriend
extends CharacterBody2D
## Docstring

#region Signals
#endregion Signals

#region Enums
enum CharacterKey {
	GO_LEFT,
	GO_RIGHT
}
#endregion Enums

#region Constants
## TODO
const MOVEMENT_SPEED = 720.0
## TODO
const MAX_MOVEMENT_SPEED_ON_FLOOR = 500.0
## TODO
const JUMP_SPEED = -400.0
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _character_keys_pool = [CharacterKey.GO_LEFT, CharacterKey.GO_RIGHT]
var _character_key : CharacterKey = CharacterKey.GO_LEFT
#endregion Private Variables

#region On Ready Variables
@onready var grappling_hook_pivot : Node2D = %GrapplingHookPivot
@onready var random_key_timer : Timer = %RandomKeyTimer
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	random_key_timer.timeout.connect(_on_random_key_timer_timeout)

func _physics_process(delta: float) -> void:
	var mouse_position := get_global_mouse_position()
	var mouse_direction := mouse_position - global_position
	
	grappling_hook_pivot.rotation = mouse_direction.angle()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var movement_direction = Vector2.ZERO
	match _character_key:
		CharacterKey.GO_LEFT:
			movement_direction = Vector2.LEFT
		CharacterKey.GO_RIGHT:
			movement_direction = Vector2.RIGHT
	
	velocity += movement_direction * MOVEMENT_SPEED * delta
	velocity.x = clamp(velocity.x, -MAX_MOVEMENT_SPEED_ON_FLOOR, MAX_MOVEMENT_SPEED_ON_FLOOR)

	move_and_slide()
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_random_key_timer_timeout() -> void:
	_set_new_character_key()
#endregion Callbacks

func _set_new_character_key() -> void:
	var _pool_copy = _character_keys_pool.duplicate()
	_pool_copy.erase(_character_key)
	_character_key = _pool_copy.pick_random()
#endregion Private Methods
