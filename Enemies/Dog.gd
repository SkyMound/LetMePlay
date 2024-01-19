extends Area2D

signal player_entered(body)
signal player_exited(body)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_jumped():
	self.get_node("Polygon2D").color = Color(1,0,0,1) # Replace with function body.

func _on_sound_range_body_entered(body):
	emit_signal("player_entered",body)


func _on_sound_range_body_exited(body):
	emit_signal("player_exited",body)
