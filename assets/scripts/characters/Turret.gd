extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export
var projectile_speed: float
var bullet = preload("res://scenes/misc/TurretProjectile.tscn")
@export var direction: Vector2 
var radianDirection: float

@onready var  attackTimer:Timer = get_node("AttackTimer")

func _ready():
	radianDirection = direction.angle_to(Vector2.RIGHT)
	attackTimer.start()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _on_attack_timer_timeout():
	attackTimer.start()
	fire_projectile(radianDirection)

func fire_projectile(direction: float):
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = get_global_position()
	bullet_instance.rotation = direction
	bullet_instance.apply_impulse(Vector2(projectile_speed, 0).rotated(direction), Vector2())
	get_tree().get_root().call_deferred("add_child", bullet_instance)
