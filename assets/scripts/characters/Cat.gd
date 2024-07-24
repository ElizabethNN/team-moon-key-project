extends CharacterBody2D



var walking_speed: float
@export
var climing_speed: float
@export
var max_speed: float
@export
var jump_speed: float
@export
var acceleration: float
@export
var deceleration: float

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var double_jump = false
var wall_jump = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if not double_jump and is_on_floor():
		double_jump = true;

	# Handle jump.
	if Input.is_action_just_pressed("movement_up") and (is_on_floor() or double_jump or wall_jump):
		double_jump = false if not is_on_floor() else double_jump
		wall_jump = false
		velocity.y = -jump_speed

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("movement_left", "movement_right")
	if direction:
		walking_speed += acceleration
		velocity.x = direction * walking_speed
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
	
	if walking_speed > max_speed:
		walking_speed = max_speed
	
	if Input.is_action_pressed("grab_wall") and is_on_wall():
		if Input.is_action_pressed("movement_up"):
			velocity.y = -climing_speed
		else:
			velocity.y = 0
		wall_jump = true
	
	

	move_and_slide()
