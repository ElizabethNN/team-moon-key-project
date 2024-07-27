extends Area2D

@export_file("*.tscn")
var next_scene: String

func _on_body_entered(body):
	if(body.get_parent().name == "Forms"):
		get_tree().change_scene_to_file(next_scene) 
