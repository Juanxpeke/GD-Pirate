class_name GrapplingHook
extends Node2D
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## TODO
const RANGE : float = 640.0
## TODO
const COOLDOWN_TIME : float = 0.0
## TODO
const MAX_HOLD_TIME : float = 0.16
## TODO
const NON_HOLD_IMPULSE_MAGNITUDE : float = 960.0
## TODO
const MAX_HOLD_IMPULSE_SPEED : float = 1280.0
## TODO
const HOLD_IMPULSE_ACCELERATION_FACTOR : float = 16.0
## TODO
const CAMERA_UNZOOM_OFFSET : Vector2 = Vector2(64.0, 64.0)
## TODO
const CAMERA_UNZOOM_SPEED_FACTOR : float = 16.0
## TODO
const CAMERA_DEFAULT_ZOOM_SPEED_FACTOR : float = 0.8
## TODO
const CAMERA_DEFAULT_ZOOM_ACTIVATION_TIME : float = 1.2
#endregion Constants

#region Exports Variables
## TODO
@export var character : CharacterBody2D = null
## TODO
@export var pivot : Node2D = null
## TODO
@export var camera : Camera2D = null
## TODO
@export var can_hold : bool = true
#endregion Exports Variables

#region Public Variables
## TODO
var enabled : bool = true
## TODO
var holding : bool = false
## TODO
var holding_point : Vector2 = Vector2.ZERO
#endregion Public Variables

#region Private Variables
var _holding_time : float = 0.0

var _default_camera_zoom : Vector2 = Vector2.ZERO
var _unzoom_camera_zoom : Vector2 = Vector2.ZERO

var _default_zoom_needed_time : float = 0.0
#endregion Private Variables

#region On Ready Variables
@onready var _sprite   : Sprite2D  = %Sprite
@onready var _ray_cast : RayCast2D = %RayCast
@onready var _pointer  : Sprite2D  = %Pointer
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	assert(character)
	assert(pivot)
	
	_ray_cast.target_position.x = RANGE
	_ray_cast.target_position.y = 0.0
	
	_default_camera_zoom = camera.zoom

func _physics_process(delta : float) -> void:
	if holding:
		_holding_time += delta
		if _holding_time > MAX_HOLD_TIME:
			_holding_time = 0.0
			holding = false
		
		var holding_point_direction := holding_point - character.global_position
		pivot.rotation = holding_point_direction.angle()
		
		var impulse_vector := holding_point - character.global_position
		var impulse_direction := impulse_vector.normalized()
		var impulse_weight := minf(HOLD_IMPULSE_ACCELERATION_FACTOR * delta, 1.0)
		character.velocity = lerp(character.velocity, impulse_direction * MAX_HOLD_IMPULSE_SPEED, impulse_weight)
	else:
		var mouse_position := get_global_mouse_position()
		var mouse_direction := mouse_position - character.global_position
		pivot.rotation = mouse_direction.angle()
		
		if abs(pivot.rotation) > PI / 2:
			_sprite.flip_v = true
			character.get_node("Sprite").flip_h = true
		else:
			_sprite.flip_v = false
			character.get_node("Sprite").flip_h = false
	
		if _ray_cast.is_colliding():
			if not _pointer.visible:
				_pointer.show()
			_pointer.rotation = mouse_direction.angle()
			
			_pointer.global_position = _ray_cast.get_collision_point()
		elif _pointer.visible:
			_pointer.hide()
		
	if camera:
		var unzoom_needed := false
		
		if _pointer.visible:
			var default_camera_size := camera.get_viewport_rect().size / _default_camera_zoom
			var default_camera_rect := Rect2(camera.get_screen_center_position() - default_camera_size * 0.5, default_camera_size)
			if not default_camera_rect.has_point(_pointer.global_position):
				unzoom_needed = true
				_default_zoom_needed_time = 0.0
				
				var desired_half_size : Vector2 = abs(_pointer.global_position - camera.get_screen_center_position()) + CAMERA_UNZOOM_OFFSET
				if desired_half_size.x > desired_half_size.y:
					_unzoom_camera_zoom = Vector2.ONE * camera.get_viewport_rect().size.x / (desired_half_size.x * 2.0)
				else:
					_unzoom_camera_zoom = Vector2.ONE * camera.get_viewport_rect().size.y / (desired_half_size.y * 2.0)
		
		if not (unzoom_needed or camera.zoom.is_equal_approx(_default_camera_zoom)):
			_default_zoom_needed_time = minf(_default_zoom_needed_time + delta, INF)
		else:
			_default_zoom_needed_time = 0.0
		
		if unzoom_needed:
			var unzoom_weight := minf(CAMERA_UNZOOM_SPEED_FACTOR * delta, 1.0)
			camera.zoom = lerp(camera.zoom, _unzoom_camera_zoom, unzoom_weight)
		elif _default_zoom_needed_time > CAMERA_DEFAULT_ZOOM_ACTIVATION_TIME:
			var zoom_weight := minf(CAMERA_DEFAULT_ZOOM_SPEED_FACTOR * delta, 1.0)
			camera.zoom = lerp(camera.zoom, _default_camera_zoom, zoom_weight)
			

func _input(event : InputEvent) -> void:
	if enabled and event.is_action_pressed("left_click") and _ray_cast.is_colliding() and not holding:
		var collision_point := _ray_cast.get_collision_point()
		
		if can_hold:
			holding = true
			holding_point = collision_point
		else:
			var impulse_vector := collision_point - character.global_position
			var impulse_direction := impulse_vector.normalized()
		
			character.velocity += impulse_direction * NON_HOLD_IMPULSE_MAGNITUDE
	elif event.is_action_released("left_click") and holding:
		holding = false
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
