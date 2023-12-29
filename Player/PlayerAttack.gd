extends Timer

@onready var attack_timer = $"."
@onready var player = $".."

var canAttack = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("attack") && canAttack :
		canAttack = false
		attack_timer.start()
		player.isAttacking = true
		


func _on_timeout():
	canAttack = true
