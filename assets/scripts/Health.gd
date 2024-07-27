extends Node

@export
var max_health: int

@onready var timer = $InvincibilityTimer

var current_health: int

signal health_changed(old_value, new_value)

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health

func change_health(delta: int):
	if not timer.is_stopped():
		return
	emit_signal("health_changed", current_health, current_health + delta)
	current_health += delta
	print(get_parent().name + ": health is " + str(current_health))
	timer.start()

func _on_invincibility_timer_timeout():
	timer.stop()
	pass # Replace with function body.
