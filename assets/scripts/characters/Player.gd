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

@export
var projectile_speed: float
var projectile = preload("res://scenes/misc/PlayerProjectile.tscn")
@onready var attack_timer = $AttackTimer

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
		# Handle acceleration
		speed += acceleration
		velocity.x = direction * speed
	else:
		# Handle deceleration
		velocity.x = move_toward(velocity.x, 0, deceleration)
	
	# Max speed
	if speed >= max_speed:
		speed = max_speed
	
	# Wall jump and wall grab
	if Input.is_action_pressed("grab_wall") and is_on_wall_only():
		velocity.y = 0
		wall_jump = true
		
	var attack_direction = Vector2()
	if(Input.is_action_pressed("attack_up")):
		attack_direction.y -= 1
	if(Input.is_action_pressed("attack_down")):
		attack_direction.y += 1
	if(Input.is_action_pressed("attack_right")):
		attack_direction.x += 1
	if(Input.is_action_pressed("attack_left")):
		attack_direction.x -= 1

	if(Input.is_action_pressed("attack") and attack_timer.is_stopped()):
		attack_timer.start()
		attack_direction = attack_direction.normalized()
		fire_projectile(Vector2.RIGHT.angle_to(attack_direction))

	move_and_slide()

func fire_projectile(direction: float):
	var bullet_instance = projectile.instantiate()
	bullet_instance.position = get_global_position()
	bullet_instance.rotation = direction
	bullet_instance.apply_impulse(Vector2(projectile_speed, 0).rotated(direction), Vector2())
	get_tree().get_root().call_deferred("add_child", bullet_instance)

func _on_attack_timer_timeout():
	attack_timer.stop()
