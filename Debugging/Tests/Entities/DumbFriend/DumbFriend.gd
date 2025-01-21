extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var grappling_hook_pivot : Node2D = %GrapplingHookPivot
@onready var random_key_timer : Timer = %RandomKeyTimer

enum CharacterKey {
	GO_LEFT,
	GO_RIGHT
}

var character_keys_pool = [CharacterKey.GO_LEFT, CharacterKey.GO_RIGHT]

var current_character_key : CharacterKey = CharacterKey.GO_LEFT

func _ready() -> void:
	random_key_timer.timeout.connect(_on_random_key_timer_timeout)

func _physics_process(delta: float) -> void:
	var mouse_position := get_global_mouse_position()
	var mouse_direction := mouse_position - global_position
	
	grappling_hook_pivot.rotation = mouse_direction.angle()
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = 0
	
	match current_character_key:
		CharacterKey.GO_LEFT:
			direction = 1
		CharacterKey.GO_RIGHT:
			direction = -1
	
	if direction != 0 and is_on_floor():
		velocity.x = direction * SPEED

	move_and_slide()
	
func _on_random_key_timer_timeout() -> void:
	current_character_key = character_keys_pool.pick_random()
