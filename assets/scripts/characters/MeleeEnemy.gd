extends CharacterBody2D


@export
var roam_speed: float
@export
var attack_speed: float
@export
var attack: int

var direction = 1

@onready var right_wall = $RightWall
@onready var left_wall = $LeftWall
@onready var left_gap = $LeftGap
@onready var right_gap = $RightGap

@onready var attack_timer = $AttackTimer
@onready var detect_timer = $DetectTimer

@onready var attack_area = $AttackArea

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player:Node2D = null

var current_state = "Idle"

var states = {
	"Idle": Callable(self, "_on_idle"),
	"MoveToAttack": Callable(self, "_on_move_to_attack"),
	"Attack": Callable(self, "_on_attack")
}

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	states.get(current_state).call()
	move_and_slide()


func _on_idle():
	if right_wall.is_colliding() or not right_gap.is_colliding():
		direction = -1
	
	if left_wall.is_colliding() or not left_gap.is_colliding():
		direction = 1
		
	if is_on_floor():
		velocity.x = roam_speed * direction

func _on_move_to_attack():
	#if we are attacking
	if not attack_timer.is_stopped():
		velocity.x = 0
		return
		
	direction = sign(player.get_global_position().x - get_global_position().x)
	
	#if we are moving to the right and we didn't fall if we continue to move to the right
	if direction == 1 and not right_wall.is_colliding() and right_gap.is_colliding():
		velocity.x = attack_speed * direction
		return
	
	#Same to the left side
	if direction == -1 and not left_wall.is_colliding() and left_gap.is_colliding():
		velocity.x = attack_speed * direction
		return
	
	#We can't move to the player but still detect it
	velocity.x = 0

func _on_attack():
	velocity.x = 0
	if(attack_timer.is_stopped()):
		attack_timer.start()

func _on_detect_area_body_entered(body):
	if(body.get_parent().name == "Forms"):
		if(not detect_timer.is_stopped()):
			detect_timer.stop()
		player = body
		current_state = "MoveToAttack"
		print(name + ": Changed to " + current_state)

func _on_detect_area_body_exited(body):
	if(body.get_parent().name == "Forms"):
		detect_timer.start()

func _on_attack_area_body_entered(body):
	if(body.get_parent().name == "Forms"):
		current_state = "Attack"
		print(name + ": Changed to " + current_state)

func _on_attack_area_body_exited(body):
	if(body.get_parent().name == "Forms"):
		current_state = "MoveToAttack"
		print(name + ": Changed to " + current_state)

func _on_attack_timer_timeout():
	attack_timer.stop()
	
	#Deal damage to playear if he still in range of attack
	if (attack_area.overlaps_body(player)):
		player.get_node("Health").change_health(-attack)

func _on_detect_timer_timeout():
	current_state = "Idle"
	print(name + ": Changed to " + current_state)
	player = null
