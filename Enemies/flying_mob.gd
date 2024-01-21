extends CharacterBody2D


const SPEED = 2000
const SPEED_RUSH = 3500
@onready var collision_shape_2d = $PlayerDetector/CollisionShape2D

@onready var health_bar = $HealthBar
@onready var animated_sprite_2d = $AnimatedSprite2D

var target = null
var starting_position = Vector2(0,0)
var going_to_target = false
func _ready() :
	health_bar.init_health(20)
	starting_position = position
	
func _physics_process(delta):
	print(going_to_target,target)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if going_to_target and target != null:
		velocity = position.direction_to(target) * SPEED_RUSH * delta
		if position.distance_to(target) < 15 :
			going_to_target = false
			target = null
	else :
		if position.distance_to(starting_position) < 3 :
			going_to_target = true
			collision_shape_2d.disabled = false
		else :
			velocity = position.direction_to(starting_position) * SPEED * delta
	move_and_slide()

	


func _on_player_detector_body_entered(body):
	if body.is_in_group("player") and target==null :
		target = body.position
		collision_shape_2d.disabled = true


func _on_hurtbox_area_entered(area):
	if(area.is_in_group("weapon")) :
		var current_health = health_bar.health
		var random_dammage = 10 + randi() % 3
		health_bar.health = current_health-random_dammage 
		if(health_bar.health <= 0) :
			animated_sprite_2d.play("death")


func _on_animated_sprite_2d_animation_looped():
	if health_bar.health <= 0 :
		queue_free()
