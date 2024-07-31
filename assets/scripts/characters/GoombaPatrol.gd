extends CharacterBody2D


@export
var speed: float
@export
var attack: int
var direction = 1

@onready var right_wall = $RightWall
@onready var left_wall = $LeftWall
@onready var left_gap = $LeftGap
@onready var right_gap = $RightGap



var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if right_wall.is_colliding() or not right_gap.is_colliding():
		direction = -1
	
	if left_wall.is_colliding() or not left_gap.is_colliding():
		direction = 1
		
	if is_on_floor():
		velocity.x = speed * direction
	
	move_and_slide()


func _on_damage_area_body_entered(body):
	if(body.get_parent().name == "Forms"):
		body.get_node("Health").change_health(-attack)
		

func _on_health_health_changed(old_value, new_value):
	if(new_value <= 0):
		queue_free()
