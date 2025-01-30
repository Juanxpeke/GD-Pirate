class_name LagTeleporter
extends Node2D
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO
@export var enabled : bool = false:
	set(new_enabled):
		if is_inside_tree() and not enabled and new_enabled:
			_lag_animation_timer.start(_rng.randf_range(min_lag_animation_cooldown, max_lag_animation_cooldown))
		enabled = new_enabled

## TODO
@export var character : CharacterBody2D = null
## TODO
@export var character_collision_shape : CollisionShape2D = null

@export_group("Recording")
## TODO
@export var record_delta_time : float = 0.25
## TODO
@export var record_frames_size : int = 16
## TODO
@export var disable_record_on_lag_animation : bool = true

@export_group("Lag Animation")
## TODO
@export var min_lag_animation_cooldown : float = 1.0
## TODO
@export var max_lag_animation_cooldown : float = 6.0
## TODO
@export var min_lag_animation_duration : float = 0.0
## TODO
@export var max_lag_animation_duration : float = 0.0
## TODO
@export var min_teleport_cooldown : float = 0.0
## TODO
@export var max_teleport_cooldown : float = 0.0
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _rng : RandomNumberGenerator = RandomNumberGenerator.new()
var _lag_animation_duration : float = 0.0
var _record_buffer : Array[CharacterRecordData] = []
var _record_enabled : bool = true
#endregion Private Variables

#region On Ready Variables
@onready var _record_timer : Timer = %RecordTimer
@onready var _lag_animation_timer : Timer = %LagAnimationTimer
@onready var _teleport_timer : Timer = %TeleportTimer
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	assert(character)
	assert(character_collision_shape)
	assert(record_delta_time < min_lag_animation_cooldown)
	assert(min_lag_animation_cooldown <= max_lag_animation_cooldown)
	assert(min_lag_animation_duration <= max_lag_animation_duration)
	assert(min_teleport_cooldown <= max_teleport_cooldown)
	
	assert(_teleport_timer.one_shot)
	assert(not _teleport_timer.autostart)
	
	assert(not _record_timer.one_shot)
	# NOTE: Assert _record_timer.autostart manually
	_record_timer.timeout.connect(_on_record_timer_timeout)
	_lag_animation_timer.timeout.connect(_on_lag_animation_timer_timeout)
	_teleport_timer.timeout.connect(_on_teleport_timer_timeout)
	
	_record_timer.wait_time = record_delta_time
	
	if enabled:
		_lag_animation_timer.start(_rng.randf_range(min_lag_animation_cooldown, max_lag_animation_cooldown))
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_lag_animation_timer_timeout() -> void:
	if enabled and not _record_buffer.is_empty():
		if disable_record_on_lag_animation:
			_record_enabled = false
		
		_lag_animation_duration = _rng.randf_range(min_lag_animation_duration, max_lag_animation_duration)
		
		_teleport()

func _on_teleport_timer_timeout() -> void:
	_teleport()

func _on_record_timer_timeout() -> void:
	if _record_enabled:
		var character_record_data : CharacterRecordData = CharacterRecordData.new()
		character_record_data.position = character.global_position
		character_record_data.velocity = character.velocity
		_record_buffer.push_front(character_record_data)
		
		if _record_buffer.size() > record_frames_size:
			_record_buffer.pop_back()
#endregion Callbacks

func _teleport() -> void:
	var random_record_index := _rng.randi_range(0, _record_buffer.size() - 1)
	character.global_position = _record_buffer[random_record_index].position
	character.velocity = _record_buffer[random_record_index].velocity
	
	var time_until_next_teleport := _rng.randf_range(min_teleport_cooldown, max_teleport_cooldown)
	
	_lag_animation_duration = max(_lag_animation_duration - time_until_next_teleport, 0.0)
	
	if _lag_animation_duration > 0.0:
		_teleport_timer.start(time_until_next_teleport)
	else:
		if disable_record_on_lag_animation:
			_record_buffer.clear()
			_record_enabled = true
		_lag_animation_timer.start(_rng.randf_range(min_lag_animation_cooldown, max_lag_animation_cooldown))

#endregion Private Methods

#region Inner Classes
class CharacterRecordData:
	var position : Vector2
	var velocity : Vector2
#endregion Inner Classes
