extends CharacterBody2D


var speed: float
@export
var max_speed: float
@export
var acceleration: float
@export
var deceleration: float
@export
var attack: int

@onready
var attack_timer = $AttackTimer

@onready
var attack_area = $AttackArea

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var wall_jump = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("movement_left", "movement_right")
	if direction:
		# Handle acceleration
		speed += acceleration
		velocity.x = direction * speed	
	else:
		# Handle deceleration
		velocity.x = move_toward(velocity.x, 0, deceleration)
	
	# Max speed
	if speed >= max_speed:
		speed = max_speed
	
	if Input.is_action_just_pressed("attack") and attack_timer.is_stopped():
		var enemies = attack_area.get_overlapping_bodies()
		for enemy in enemies:
			if enemy.has_node("Health"):
				enemy.get_node("Health").change_health(-attack)
	
	move_and_slide()


func _on_attack_timer_timeout():
	attack_timer.stop()
