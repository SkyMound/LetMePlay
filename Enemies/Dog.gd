extends Area2D

signal player_entered(body)
signal player_exited(body)

@export var sprite_sleep : Texture2D
@export var sprite_attack : Texture2D

var attack = false

func _ready():
	$Sprite2D.texture = sprite_sleep
	
func _on_player_jumped():
	$Sprite2D.texture = sprite_attack
	attack = true

func _on_sound_range_body_entered(body):
	emit_signal("player_entered",body)

func _on_sound_range_body_exited(body):
	emit_signal("player_exited",body)
	$Sprite2D.texture = sprite_sleep
	attack = false

func _on_body_entered(body):
	if body.get_name() == "Player" and attack:
		body.queue_free()
