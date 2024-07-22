extends CharacterBody2D


@export
var speed: float
@export
var jump_speed: float

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var double_jump = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if not double_jump and is_on_floor():
		double_jump = true;

	# Handle jump.
	if Input.is_action_just_pressed("movement_up") and (is_on_floor() or double_jump):
		double_jump = false if not is_on_floor() else double_jump
		velocity.y = -jump_speed

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("movement_left", "movement_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
