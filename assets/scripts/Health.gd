extends Node

@export
var max_health: int

@onready var timer = $InvincibilityTimer

var current_health: int

@onready
var health_bar = $"../HealthBar"

signal health_changed(old_value, new_value)

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health

func change_health(delta: int):
	health_bar.value = current_health
	if not timer.is_stopped():
		return
	emit_signal("health_changed", current_health, current_health + delta)
	current_health += delta
	print(get_parent().name + ": health is " + str(current_health))
	timer.start()
	

	if current_health >= 6:
		health_bar.visible = false
	else:
		health_bar.visible = true

func _on_invincibility_timer_timeout():
	timer.stop()
	pass # Replace with function body.
