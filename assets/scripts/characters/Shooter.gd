extends CharacterBody2D

@export
var speed: float
@export
var projectile_speed: float

var bullet = preload("res://scenes/misc/ShooterProjectile.tscn")

signal collided_with_something(collisions: Array[KinematicCollision2D])

@onready var player: Node2D = get_parent().get_node("Player")
var x = 20

func _physics_process(delta):
	
	var collisions = []
	for i in get_slide_collision_count():
		collisions += [get_slide_collision(i)]
	if(x == 0):
		fire_projectile(get_angle_to(player.position))
		x = 20
	x-=1
	
	emit_signal("collided_with_something", collisions)
	move_and_slide()

func fire_projectile(direction: float):
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = get_global_position()
	bullet_instance.rotation = direction
	bullet_instance.apply_impulse(Vector2(projectile_speed, 0).rotated(direction), Vector2())
	get_tree().get_root().call_deferred("add_child", bullet_instance)
