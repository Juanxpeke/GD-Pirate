class_name DumbFriend
extends CharacterBody2D
## Docstring

#region Signals
#endregion Signals

#region Enums
enum CharacterKey {
	GO_LEFT,
	GO_RIGHT,
	JUMP,
	STOMP
}
#endregion Enums

#region Constants
## TODO
const MOVEMENT_ACCELERATION_ON_FLOOR = 720.0
## TODO
const MOVEMENT_ACCELERATION_ON_AIR = 800.0
## TODO
const MAX_MOVEMENT_SPEED_ON_FLOOR = 500.0
## TODO
const MAX_MOVEMENT_SPEED_ON_AIR = 1000.0
## TODO
const MIN_RANDOM_KEY_TIME : float = 1.0
## TODO
const MAX_RANDOM_KEY_TIME : float = 4.0
## TODO
const JUMP_SPEED = -400.0
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _rng : RandomNumberGenerator = RandomNumberGenerator.new()
var _character_keys_pool = [CharacterKey.GO_LEFT, CharacterKey.GO_RIGHT]
var _character_key : CharacterKey = CharacterKey.GO_LEFT
#endregion Private Variables

#region On Ready Variables
@onready var grappling_hook_pivot : Node2D = %GrapplingHookPivot
@onready var random_key_timer : Timer = %RandomKeyTimer
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_rng.randomize()
	
	random_key_timer.timeout.connect(_on_random_key_timer_timeout)
	
	random_key_timer.start(_rng.randf_range(MIN_RANDOM_KEY_TIME, MAX_RANDOM_KEY_TIME))

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
	
	if is_on_floor():
		velocity += movement_direction * MOVEMENT_ACCELERATION_ON_FLOOR * delta
		velocity.x = clamp(velocity.x, -MAX_MOVEMENT_SPEED_ON_FLOOR, MAX_MOVEMENT_SPEED_ON_FLOOR)
	else:
		velocity += movement_direction * MOVEMENT_ACCELERATION_ON_AIR * delta
		velocity.x = clamp(velocity.x, -MAX_MOVEMENT_SPEED_ON_AIR, MAX_MOVEMENT_SPEED_ON_AIR)

	move_and_slide()
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_random_key_timer_timeout() -> void:
	_set_new_character_key()
	
	var time := _rng.randf_range(MIN_RANDOM_KEY_TIME, MAX_RANDOM_KEY_TIME)
	random_key_timer.start(time)
#endregion Callbacks

func _set_new_character_key() -> void:
	var _pool_copy = _character_keys_pool.duplicate()
	_pool_copy.erase(_character_key)
	_character_key = _pool_copy.pick_random()
#endregion Private Methods
