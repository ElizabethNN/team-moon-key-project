extends Node2D

@onready var Scene_transtion_animation = $Scene_transition_animation/AnimationPlayer
@export
var destination: String

func _ready():
	Scene_transtion_animation.get_parent().get_node("ColorRect").color.a = 255
	Scene_transtion_animation.play("fade_out")

func _on_room_2_body_entered(body):
	if body is Player:
		Scene_transtion_animation.play("fade_in")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(destination)
