extends CharacterBody2D

class_name Player

var speed: float
@export
var max_speed: float
@export
var jump_speed: float
@export
var wall_jump_power: float
@export
var acceleration: float
@export
var deceleration: float

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var wall_jump = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("movement_up") and (is_on_floor() or wall_jump):
		velocity.y = -jump_speed
		wall_jump = false



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("movement_left", "movement_right")
	if direction:
		speed += acceleration
		velocity.x = direction * speed	
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
	

	if speed >= max_speed:
		speed = max_speed
	
	
	if Input.is_action_pressed("grab_wall") and is_on_wall_only():
		velocity.y = 0
		wall_jump = true

	move_and_slide()

