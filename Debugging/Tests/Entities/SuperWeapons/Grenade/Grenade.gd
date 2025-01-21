class_name Grenade
extends RigidBody2D
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## TODO
const MAX_CONTACTS_REPORTED : int = 6
## TODO
const MAX_COLLISION_OFFSET_FOR_IMPULSE : float = 32.0
## TODO
const MAX_ANGLE_BETWEEN_CONTACT_AND_IMPULSE : float = deg_to_rad(60)
## TODO
const BASE_IMPULSE_MAGNITUDE : float = 240.0
## TODO
const MAX_MOVEMENT_SPEED : float = 100.0
## TODO
const GAUGE_ROTATION_SPEED : float = deg_to_rad(640.0)
#endregion Constants

#region Exports Variables
## TODO
@export var initial_impulse_direction : Vector2 = Vector2.ZERO
## TODO
@export var initial_impulse_magnitude : float = 0.0
## TODO
@export var offset_impulse_factor_curve : Curve
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var collision_shape : CollisionShape2D = %CollisionShape
@onready var gauge_pivot := %GaugePivot
@onready var gauge := %Gauge
@onready var gauge_ray : RayCast2D = %GaugeRay
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_force_physics_parameters()
	_assert_physics_parameters()
	
	gauge_ray.target_position.y = 0.0
	gauge_ray.target_position.x = collision_shape.shape.radius + MAX_COLLISION_OFFSET_FOR_IMPULSE
	
	initial_impulse_direction = initial_impulse_direction.normalized()
	apply_impulse(initial_impulse_direction * initial_impulse_magnitude)

func _physics_process(delta: float) -> void:
	gauge_pivot.global_position = global_position
	
	if Input.is_action_pressed("move_left"):
		gauge_pivot.rotate(-GAUGE_ROTATION_SPEED * delta)
	if Input.is_action_pressed("move_right"):
		gauge_pivot.rotate(GAUGE_ROTATION_SPEED * delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("active"):
		var impulse_direction : Vector2 = (global_position - gauge.global_position).normalized()
		
		if gauge_ray.is_colliding():
			var collision_distance : float = gauge_ray.get_collision_point().distance_to(global_position)
			var collision_offset : float = collision_distance - collision_shape.shape.radius
			var impulse_magnitude_factor : float = offset_impulse_factor_curve.sample(collision_offset / MAX_COLLISION_OFFSET_FOR_IMPULSE)
			
			if abs(linear_velocity.angle_to(impulse_direction)) > abs(deg_to_rad(135)):
				linear_velocity = Vector2.ZERO
			apply_impulse(impulse_direction * impulse_magnitude_factor * BASE_IMPULSE_MAGNITUDE)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _force_physics_parameters() -> void:
	contact_monitor = true
	max_contacts_reported = MAX_CONTACTS_REPORTED

func _assert_physics_parameters() -> void:
	assert(contact_monitor)
	assert(max_contacts_reported > 0)
	assert(collision_shape.shape is CircleShape2D)
#endregion Private Methods

#region Inner Classes
#endregion Inner Classes
