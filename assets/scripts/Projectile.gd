extends RigidBody2D

@export
var damage: int

func get_damage():
	return damage


func _on_body_entered(body):
	if body.has_node("Health"):
		var hp = body.get_node("Health").change_health(damage)
	queue_free()


func _on_projectile_timeout_timer_timeout():
	queue_free()
