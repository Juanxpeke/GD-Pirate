class_name DumbFriend
extends CharacterBody2D
## Docstring

#region Signals
#endregion Signals

#region Enums
## TODO
enum BehaviourMode {
	## TODO
	NONE,
	## TODO
	FOLLOWING_TARGET,
	## TODO
	RANDOM
}
## TODO
enum CharacterKey {
	## TODO
	NONE,
	## TODO
	GO_LEFT,
	## TODO
	GO_RIGHT,
	## TODO
	JUMP,
	## TODO
	STOMP,
	## TODO
	CHANGE_WEAPON
}
#endregion Enums

#region Constants
## TODO
const INITIAL_IDLE_TIME : float = 2.0
## TODO
const HORIZONTAL_MOVEMENT_ACCELERATION_ON_FLOOR : float = 2160.0
## TODO
const HORIZONTAL_MOVEMENT_FRICTION_ON_FLOOR : float = 1280.0
## TODO
const HORIZONTAL_MOVEMENT_ACCELERATION_ON_AIR : float = 2640.0
## TODO
const MAX_HORIZONTAL_MOVEMENT_SPEED_ON_FLOOR : float = 500.0
## TODO
const MAX_HORIZONTAL_MOVEMENT_SPEED_ON_AIR : float = 700.0
## TODO
const MAX_VERTICAL_MOVEMENT_SPEED : float = 1800.0
## TODO
const STOMP_HORIZONTAL_FRICTION : float = 2000.0
## TODO
const STOMP_VERTICAL_ACCELERATION : float = 3200.0
## TODO
const MIN_RANDOM_KEY_TIME : float = 1.0
## TODO
const MAX_RANDOM_KEY_TIME : float = 4.0
## TODO
const CHARACTER_KEYS_DATA = {
	CharacterKey.NONE : {
		"name": "",
		"weight": 0.1,
		"min_time": MIN_RANDOM_KEY_TIME,
		"max_time": MAX_RANDOM_KEY_TIME,
	},
	CharacterKey.GO_LEFT : {
		"name": "A",
		"weight": 1.0,
		"min_time": MIN_RANDOM_KEY_TIME,
		"max_time": MAX_RANDOM_KEY_TIME,
	},
	CharacterKey.GO_RIGHT : {
		"name": "D",
		"weight": 1.0,
		"min_time": MIN_RANDOM_KEY_TIME,
		"max_time": MAX_RANDOM_KEY_TIME,
	},
	CharacterKey.STOMP : {
		"name": "S",
		"weight": 0.2,
		"min_time": MIN_RANDOM_KEY_TIME,
		"max_time": MAX_RANDOM_KEY_TIME,
	}
}
#endregion Constants

#region Exports Variables
@export var behaviour_mode : BehaviourMode = BehaviourMode.NONE:
	set(new_behaviour_mode):
		match new_behaviour_mode:
			BehaviourMode.NONE:
				print("NONE")
			BehaviourMode.FOLLOWING_TARGET:
				print("FOLLOWING TARGET")
			BehaviourMode.RANDOM:
				print("RANDOM")
		
		behaviour_mode = new_behaviour_mode
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _rng : RandomNumberGenerator = RandomNumberGenerator.new()

var _character_keys_pool = [CharacterKey.NONE, CharacterKey.GO_LEFT, CharacterKey.GO_RIGHT, CharacterKey.STOMP]

var _character_key : CharacterKey = CharacterKey.NONE:
	set(new_character_key):
		_random_key_label.text = CHARACTER_KEYS_DATA[new_character_key].name
		
		if new_character_key == CharacterKey.STOMP:
			_stomp_area.monitoring = true
		else:
			_stomp_area.monitoring = false
		
		_character_key = new_character_key
#endregion Private Variables

#region On Ready Variables
@onready var _stomp_area       : Area2D = %StompArea
@onready var _random_key_timer : Timer  = %RandomKeyTimer
@onready var _random_key_label : Label  = %RandomKeyLabel
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_assert_parameters()
	_initial_connections()
	_initial_setup()

func _physics_process(delta: float) -> void:
	
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
	_set_random_character_key()
#endregion Callbacks
#region Initialization
func _initial_connections() -> void:
	_stomp_area.body_shape_entered.connect(_on_stomp_area_shape_entered)
	_random_key_timer.timeout.connect(_on_random_key_timer_timeout)

func _initial_setup() -> void:
	_rng.randomize()
	
	_init_random_stuff()
#endregion Initialization
func _init_random_stuff() -> void:
	var timer := get_tree().create_timer(INITIAL_IDLE_TIME)
	await timer.timeout
	_set_random_character_key()

func _set_random_character_key(exclude_current : bool = true) -> void:
	var pool_copy := _character_keys_pool.duplicate()
	if exclude_current:
		pool_copy.erase(_character_key)

	var pool_keys_total_weight := 0.0
	for key in pool_copy:
		pool_keys_total_weight += CHARACTER_KEYS_DATA[key].weight

	var random_weight := _rng.randf_range(0.0, pool_keys_total_weight)
	
	var final_key : CharacterKey
	for key in pool_copy:
		final_key = key
		random_weight -= CHARACTER_KEYS_DATA[key].weight
		if random_weight < 0.0:
			break
	
	_character_key = final_key
	
	var min_time : float = CHARACTER_KEYS_DATA[_character_key].min_time
	var max_time : float = CHARACTER_KEYS_DATA[_character_key].max_time
	_random_key_timer.start(_rng.randf_range(min_time, max_time))
#endregion Private Methods
