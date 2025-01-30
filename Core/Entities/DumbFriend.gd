class_name DumbFriend
extends CharacterBody2D
## Docstring

#region Signals
## TODO
signal stomped_tile
#endregion Signals

#region Enums
## TODO
enum BehaviourMode {
	## TODO
	NONE,
	## TODO
	FOLLOWING_TARGET,
	## TODO
	STOMP,
	## TODO
	RANDOM,
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
	STOMP,
}
#endregion Enums

#region Constants
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
const FOLLOW_TARGET_ACCEPTED_DELTA_X : float = 40.0

## TODO
const INITIAL_IDLE_TIME : float = 2.0
## TODO
const MIN_RANDOM_KEY_TIME : float = 1.0
## TODO
const MAX_RANDOM_KEY_TIME : float = 4.0

## TODO
const STUN_TIME : float = 2.0

## TODO
const DEFAULT_CHARACTER_KEYS_DATA : Dictionary = {
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
		behaviour_mode = new_behaviour_mode
		if is_inside_tree():
			_behaviour_mode_initialization()
			LogManager.character_log("Behaviour mode set to %s" % behaviour_mode)
#endregion Exports Variables

#region Public Variables
## TODO
var character_keys_data : Dictionary = DEFAULT_CHARACTER_KEYS_DATA
## TODO
var follow_target : Vector2 = Vector2.ZERO
#endregion Public Variables

#region Private Variables
var _rng : RandomNumberGenerator = RandomNumberGenerator.new()

var _character_keys_pool = [CharacterKey.NONE, CharacterKey.GO_LEFT, CharacterKey.GO_RIGHT, CharacterKey.STOMP]

var _character_key : CharacterKey = CharacterKey.NONE:
	set(new_character_key):
		## TODO: Call dialogue
		
		if new_character_key == CharacterKey.STOMP:
			_stomp_area.monitoring = true
		else:
			_stomp_area.monitoring = false
		
		_character_key = new_character_key

var _stunned : bool = false
#endregion Private Variables

#region On Ready Variables
@onready var _grappling_hook   : GrapplingHook = %GrapplingHook
@onready var _lag_teleporter   : LagTeleporter = %LagTeleporter
@onready var _stomp_area       : Area2D        = %StompArea
@onready var _stunnable_area   : Area2D        = %StunnableArea
@onready var _random_key_timer : Timer         = %RandomKeyTimer
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_assert_parameters()
	_initial_connections()
	_initial_setup()

func _physics_process(delta: float) -> void:
	_physics_process_behaviour()
	_physics_process_movement(delta)

func _physics_process_behaviour() -> void:
	match behaviour_mode:
		BehaviourMode.NONE:
			pass
		BehaviourMode.FOLLOWING_TARGET:
			var delta_x : float = follow_target.x - global_position.x
			
			if abs(delta_x) > FOLLOW_TARGET_ACCEPTED_DELTA_X:
				if delta_x > 0:
					_character_key = CharacterKey.GO_RIGHT
				else:
					_character_key = CharacterKey.GO_LEFT
			else:
				_character_key = CharacterKey.NONE
		BehaviourMode.RANDOM:
			pass

func _physics_process_movement(delta : float) -> void:
	var horizontal_movement_direction = Vector2.ZERO
	if not _stunned:
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
	
	if _character_key == CharacterKey.STOMP and not _stunned:
		velocity.x = move_toward(velocity.x, 0.0, delta * STOMP_HORIZONTAL_FRICTION)
		velocity.y += STOMP_VERTICAL_ACCELERATION * delta
	
	velocity.y = clamp(velocity.y, -MAX_VERTICAL_MOVEMENT_SPEED, MAX_VERTICAL_MOVEMENT_SPEED)
	
	move_and_slide()
#endregion Built-in Virtual Methods

#region Public Methods
## TODO
func enable_lag_teleporter() -> void:
	_lag_teleporter.enabled = true
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
		
		if tile_data:
			if tile_data.get_custom_data("Breakable"):
				dumb_tile_map_layer.erase_cell(coords)
				stomped_tile.emit()
		else:
			LogManager.physics_log("Not tile data found at %s" % coords)

func _on_stunnable_area_shape_entered(body_rid : RID, body : Node2D, _body_shape_index : int, _local_shape_index : int) -> void:
	if body is DumbTileMapLayer:
		var dumb_tile_map_layer : DumbTileMapLayer = body
		
		var coords := dumb_tile_map_layer.get_coords_for_body_rid(body_rid)
		
		var tile_data := dumb_tile_map_layer.get_cell_tile_data(coords)
		
		if tile_data:
			if tile_data.get_custom_data("Can Stun") and not _stunned:
				_stunned = true
				_grappling_hook.holding = false
				_grappling_hook.enabled = false
				var timer := get_tree().create_timer(STUN_TIME)
				await timer.timeout
				_grappling_hook.enabled = true
				_stunned = false
		else:
			LogManager.physics_log("Not tile data found at %s" % coords)

func _on_random_key_timer_timeout() -> void:
	_set_random_character_key()
#endregion Callbacks
#region Initialization
func _initial_connections() -> void:
	_stomp_area.body_shape_entered.connect(_on_stomp_area_shape_entered)
	_stunnable_area.body_shape_entered.connect(_on_stunnable_area_shape_entered)
	_random_key_timer.timeout.connect(_on_random_key_timer_timeout)

func _initial_setup() -> void:
	_rng.randomize()
	_behaviour_mode_initialization()

func _behaviour_mode_initialization() -> void:
	match behaviour_mode:
		BehaviourMode.NONE:
			_character_key = CharacterKey.NONE
		BehaviourMode.FOLLOWING_TARGET:
			_character_key = CharacterKey.NONE
		BehaviourMode.STOMP:
			_character_key = CharacterKey.STOMP
		BehaviourMode.RANDOM:
			var timer := get_tree().create_timer(INITIAL_IDLE_TIME)
			await timer.timeout ## NOTE: This can lead to a bug when multiple initialization
			_set_random_character_key()
#endregion Initialization

func _set_random_character_key(exclude_current : bool = true) -> void:
	var pool_copy := _character_keys_pool.duplicate()
	if exclude_current:
		pool_copy.erase(_character_key)

	var pool_keys_total_weight := 0.0
	for key in pool_copy:
		pool_keys_total_weight += character_keys_data[key].weight

	var random_weight := _rng.randf_range(0.0, pool_keys_total_weight)
	
	var final_key : CharacterKey
	for key in pool_copy:
		final_key = key
		random_weight -= character_keys_data[key].weight
		if random_weight < 0.0:
			break
	
	_character_key = final_key
	
	var min_time : float = character_keys_data[_character_key].min_time
	var max_time : float = character_keys_data[_character_key].max_time
	_random_key_timer.start(_rng.randf_range(min_time, max_time))
#endregion Private Methods
