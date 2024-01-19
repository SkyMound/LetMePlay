extends Area2D

signal player_entered(body)
signal player_exited(body)

var attack = false

func _ready():
	self.get_node("Polygon2D").color = Color(0,1,0,1)

func _on_player_jumped():
	self.get_node("Polygon2D").color = Color(1,0,0,1)
	attack = true

func _on_sound_range_body_entered(body):
	emit_signal("player_entered",body)

func _on_sound_range_body_exited(body):
	emit_signal("player_exited",body)
	self.get_node("Polygon2D").color = Color(0,1,0,1)
	attack = false

func _on_body_entered(body):
	if body.get_name() == "Player" and attack:
		body.queue_free()
