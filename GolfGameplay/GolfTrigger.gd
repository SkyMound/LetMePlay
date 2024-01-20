extends Area2D

@export var player_golf_scene : PackedScene

var player_pos
var done = 0

func _on_body_entered(body):
	if done == 0:
		var player = get_node("/root/GolfRoom/Player")
		var player_golf = player_golf_scene.instantiate()
		player.queue_free()
		add_child(player_golf)
		done = 1
