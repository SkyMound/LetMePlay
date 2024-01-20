extends Area2D

@export var targetScene : String

func _on_body_entered(body):
	if body.name == "Player" or body.name == "PlayerGolf":
		get_tree().change_scene_to_file(targetScene)
