extends ProgressBar


@onready var timer = $Timer
@onready var damage_bar = $DamageBar

var health = 0 : set = _set_health


func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	print(value)
	
#	if health <=0:
#		#queue_free()
#		health = 50
	if health < prev_health:
		timer.start()
	elif new_health <= max_value:
		damage_bar.value = health
	elif new_health > max_value:
		damage_bar.value = max_value
		

func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health
	
	

func _on_timer_timeout():
	damage_bar.value = health
	
