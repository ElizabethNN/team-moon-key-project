extends CharacterBody2D

@export
var projectile_speed: float
@export
var roam_speed: float
@export
var attack_speed: float
@export
var ignore_idle: bool

var direction = 1

@onready 
var attack_timer = $AttackTimer
@onready 
var idle_timer = $IdleTimer
@onready
var current_state = "MoveToAttack" if ignore_idle else "Idle"

var player: Node2D

var bullet = preload("res://scenes/misc/ShooterProjectile.tscn")

var states = {
	"Idle": Callable(self, "_on_idle"),
	"MoveToAttack": Callable(self, "_on_move_to_attack"),
	"Attack": Callable(self, "_on_attack"),
	"Flee": Callable(self, "_on_flee")
	}

func _physics_process(delta):
	states.get(current_state).call()
	
	move_and_slide()

func fire_projectile(direction: float):
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = get_global_position()
	bullet_instance.rotation = direction
	bullet_instance.apply_impulse(Vector2(projectile_speed, 0).rotated(direction), Vector2())
	get_tree().get_root().call_deferred("add_child", bullet_instance)

func _on_idle():
	pass

func _on_move_to_attack():
	if(player == null):
		player = get_parent().get_node("Forms").current_form
	var player_direction =  player.get_global_position() - get_global_position()
	velocity = player_direction.normalized() * attack_speed
	
func _on_attack():
	if(player == null):
		player = get_parent().get_node("Forms").current_form
	var player_direction = player.get_global_position() - get_global_position()
	if(attack_timer.is_stopped()):
		fire_projectile(Vector2.RIGHT.angle_to(player_direction))
		attack_timer.start()
	
	
func _on_flee():
	if(player == null):
		player = get_parent().get_node("Forms").current_form
	var player_direction =  get_global_position() - player.get_global_position()
	velocity = player_direction.normalized() * attack_speed
	if(attack_timer.is_stopped()):
		attack_timer.start()
		fire_projectile(Vector2.LEFT.angle_to(player_direction))
	

func _on_detection_area_body_entered(body):
	if(body.get_parent().name == "Forms"):
		idle_timer.stop()
		player = body
		current_state = "MoveToAttack"
		print(name + ": Changed to " + current_state)


func _on_detection_area_body_exited(body):
	if(not ignore_idle and body.get_parent().name == "Forms"):
		idle_timer.start()
		current_state = "Idle"
		print(name + ": Changed to " + current_state)
		player = null


func _on_attack_radius_body_entered(body):
	if(body.get_parent().name == "Forms"):
		idle_timer.stop()
		current_state = "Attack"
		print(name + ": Changed to " + current_state)


func _on_attack_radius_body_exited(body):
	if(body.get_parent().name == "Forms"):
		idle_timer.stop()
		current_state = "MoveToAttack"
		print(name + ": Changed to " + current_state)


func _on_safe_area_body_entered(body):
	if(body.get_parent().name == "Forms"):
		idle_timer.stop()
		current_state = "Flee"
		print(name + ": Changed to " + current_state)


func _on_safe_area_body_exited(body):
	if(body.get_parent().name == "Forms"):
		idle_timer.stop()
		current_state = "Attack"
		print(name + ": Changed to " + current_state)

func _on_attack_timer_timeout():
	attack_timer.stop()


func _on_idle_timer_timeout():
	direction *= -1
	var random_delta = randf_range(-roam_speed/2, roam_speed/2)
	velocity.y = (roam_speed - random_delta) * direction
	velocity.x = random_delta
	idle_timer.stop()
	idle_timer.start()

func _on_health_health_changed(old_value, new_value):
	if(new_value <= 0):
		queue_free()
