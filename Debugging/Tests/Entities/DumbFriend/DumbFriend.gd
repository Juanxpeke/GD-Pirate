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
const HORIZONTAL_MOVEMENT_ACCELERATION_ON_FLOOR : float = 720.0
## TODO
const HORIZONTAL_MOVEMENT_FRICTION_ON_FLOOR : float = 1280.0
## TODO
const HORIZONTAL_MOVEMENT_ACCELERATION_ON_AIR : float = 800.0
## TODO
const MAX_HORIZONTAL_MOVEMENT_SPEED_ON_FLOOR : float = 500.0
## TODO
const MAX_HORIZONTAL_MOVEMENT_SPEED_ON_AIR : float = 1000.0
## TODO
const MAX_VERTICAL_MOVEMENT_SPEED : float = 2000.0
## TODO
const MIN_RANDOM_KEY_TIME : float = 1.0
## TODO
const MAX_RANDOM_KEY_TIME : float = 4.0
## TODO
const STOMP_HORIZONTAL_FRICTION : float = 2000.0
## TODO
const STOMP_VERTICAL_ACCELERATION : float = 4000.0
## TODO
const CHARACTER_KEYS_DATA = {
	CharacterKey.GO_LEFT : {
		"name": "A",
		"weight": 1.0
	},
	CharacterKey.GO_RIGHT : {
		"name": "D",
		"weight": 1.0
	},
	CharacterKey.STOMP : {
		"name": "S",
		"weight": 0.2
	}
}
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _rng : RandomNumberGenerator = RandomNumberGenerator.new()
var _character_keys_pool = [CharacterKey.GO_LEFT, CharacterKey.GO_RIGHT, CharacterKey.STOMP]
var _character_key : CharacterKey = CharacterKey.NONE
#endregion Private Variables

#region On Ready Variables
@onready var _grappling_hook_pivot : Node2D = %GrapplingHookPivot
@onready var _stomp_area           : Area2D = %StompArea
@onready var _random_key_timer     : Timer  = %RandomKeyTimer
@onready var _random_key_label     : Label  = %RandomKeyLabel
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_assert_parameters()
	_initial_connections()
	_initial_setup()

func _physics_process(delta: float) -> void:
	var mouse_position := get_global_mouse_position()
	var mouse_direction := mouse_position - global_position
	
	_grappling_hook_pivot.rotation = mouse_direction.angle()
	
	var horizontal_movement_direction = Vector2.ZERO
	match _character_key:
		CharacterKey.GO_LEFT:
			horizontal_movement_direction = Vector2.LEFT
		CharacterKey.GO_RIGHT:
			horizontal_movement_direction = Vector2.RIGHT
	
	if is_on_floor():
		velocity += horizontal_movement_direction * HORIZONTAL_MOVEMENT_ACCELERATION_ON_FLOOR * delta
		velocity.x = clamp(velocity.x, -MAX_HORIZONTAL_MOVEMENT_SPEED_ON_FLOOR, MAX_HORIZONTAL_MOVEMENT_SPEED_ON_FLOOR)
		if abs(velocity.x) > 0.0 and horizontal_movement_direction == Vector2.ZERO:
			velocity.x = move_toward(velocity.x, 0.0, HORIZONTAL_MOVEMENT_FRICTION_ON_FLOOR * delta)
	else:
		velocity += horizontal_movement_direction * HORIZONTAL_MOVEMENT_ACCELERATION_ON_AIR * delta
		velocity.x = clamp(velocity.x, -MAX_HORIZONTAL_MOVEMENT_SPEED_ON_AIR, MAX_HORIZONTAL_MOVEMENT_SPEED_ON_AIR)
	
	velocity += get_gravity() * delta
	
	if _character_key == CharacterKey.STOMP:
		velocity.x = move_toward(velocity.x, 0.0, delta * STOMP_HORIZONTAL_FRICTION)
		velocity.y += STOMP_VERTICAL_ACCELERATION * delta
	
	velocity.y = clamp(velocity.y, -MAX_VERTICAL_MOVEMENT_SPEED, MAX_VERTICAL_MOVEMENT_SPEED)
	
	move_and_slide()
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Assertions
func _assert_parameters() -> void:
	assert(not _stomp_area.monitoring) # NOTE: Should be monitoring only when stomp key is pressed
#endregion Assertions
#region Callbacks
func _on_stomp_area_shape_entered(body_rid : RID, body : Node2D, _body_shape_index : int, _local_shape_index : int) -> void:
	if body is DumbTileMapLayer:
		var dumb_tile_map_layer : DumbTileMapLayer = body
		
		var coords := dumb_tile_map_layer.get_coords_for_body_rid(body_rid)
		
		var tile_data := dumb_tile_map_layer.get_cell_tile_data(coords)
		
		if tile_data.get_custom_data("Breakable"):
			dumb_tile_map_layer.erase_cell(coords)

func _on_random_key_timer_timeout() -> void:
	_set_new_character_key()
#endregion Callbacks
#region Initialization
func _initial_connections() -> void:
	_stomp_area.body_shape_entered.connect(_on_stomp_area_shape_entered)
	_random_key_timer.timeout.connect(_on_random_key_timer_timeout)

func _initial_setup() -> void:
	_rng.randomize()
	
	var timer := get_tree().create_timer(INITIAL_IDLE_TIME)
	await timer.timeout
	
	_set_new_character_key(false)
#endregion Initialization
func _set_new_character_key(exclude_current : bool = true) -> void:
	var pool_copy := _character_keys_pool.duplicate()
	if exclude_current:
		pool_copy.erase(_character_key)

	var pool_keys_total_weight := 0.0
	for key in pool_copy:
		pool_keys_total_weight += CHARACTER_KEYS_DATA[key].weight

	var random_weight := _rng.randf_range(0.0, pool_keys_total_weight)
	
	for key in pool_copy:
		_character_key = key
		random_weight -= CHARACTER_KEYS_DATA[key].weight
		if random_weight < 0.0:
			break
	
	_random_key_label.text = CHARACTER_KEYS_DATA[_character_key].name
	
	if _character_key == CharacterKey.STOMP:
		_stomp_area.monitoring = true
	else:
		_stomp_area.monitoring = false
	
	_random_key_timer.start(_rng.randf_range(MIN_RANDOM_KEY_TIME, MAX_RANDOM_KEY_TIME))
#endregion Private Methods
