class_name DumbFriend
extends CharacterBody2D
## Docstring

#region Signals
#endregion Signals

#region Enums
enum CharacterKey {
	NONE,
	GO_LEFT,
	GO_RIGHT,
	JUMP,
	STOMP,
	CHANGE_WEAPON
}
#endregion Enums

#region Constants
## TODO
const INITIAL_IDLE_TIME : float = 2.0
## TODO
const MOVEMENT_ACCELERATION_ON_FLOOR : float = 720.0
## TODO
const MOVEMENT_ACCELERATION_ON_AIR : float = 800.0
## TODO
const MAX_MOVEMENT_SPEED_ON_FLOOR : float = 500.0
## TODO
const MAX_MOVEMENT_SPEED_ON_AIR : float = 1000.0
## TODO
const MIN_RANDOM_KEY_TIME : float = 1.0
## TODO
const MAX_RANDOM_KEY_TIME : float = 4.0
## TODO
const JUMP_SPEED = -400.0
## TODO
const KEYS_DATA = {
	CharacterKey.GO_LEFT : {
		"name": "A"
	},
	CharacterKey.GO_RIGHT : {
		"name": "D"
	}
}
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _rng : RandomNumberGenerator = RandomNumberGenerator.new()
var _character_keys_pool = [CharacterKey.GO_LEFT, CharacterKey.GO_RIGHT]
var _character_key : CharacterKey = CharacterKey.NONE
#endregion Private Variables

#region On Ready Variables
@onready var _grappling_hook_pivot : Node2D = %GrapplingHookPivot
@onready var _random_key_timer     : Timer  = %RandomKeyTimer
@onready var _random_key_label     : Label  = %RandomKeyLabel
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_initial_connections()
	_initial_setup()

func _physics_process(delta: float) -> void:
	var mouse_position := get_global_mouse_position()
	var mouse_direction := mouse_position - global_position
	
	_grappling_hook_pivot.rotation = mouse_direction.angle()
	
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
#endregion Callbacks
#region Initialization
func _initial_connections() -> void:
	_random_key_timer.timeout.connect(_on_random_key_timer_timeout)

func _initial_setup() -> void:
	_rng.randomize()
	
	var timer := get_tree().create_timer(INITIAL_IDLE_TIME)
	await timer.timeout
	
	_set_new_character_key(false)
#endregion Initialization
func _set_new_character_key(exclude_current : bool = true) -> void:
	var _pool_copy = _character_keys_pool.duplicate()
	
	if exclude_current:
		_pool_copy.erase(_character_key)
	
	_character_key = _pool_copy.pick_random()
	
	_random_key_label.text = KEYS_DATA[_character_key].name
	
	_random_key_timer.start(_rng.randf_range(MIN_RANDOM_KEY_TIME, MAX_RANDOM_KEY_TIME))
#endregion Private Methods
