extends CharacterBody2D

@onready var health_bar = $HealthBar
@onready var animated_sprite_2d = $AnimatedSprite2D

@export var x_left = 20
@export var x_right = 180
@export var speed = 2000
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var starting_x_position = position.x
var going_left = false
# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("default")
	randomize()
	health_bar.init_health(30)
	starting_x_position = position.x
	
func apply_gravity(delta) :
	if not is_on_floor():
		velocity.y += gravity * delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	apply_gravity(delta)
	velocity.x = -speed*delta if going_left else speed*delta
	if position.x - starting_x_position > x_right :
		going_left = true
		scale.x = 1
	elif position.x - starting_x_position < -x_left :
		going_left = false
		scale.x = -1
		
	move_and_slide()


func _on_area_2d_area_entered(area):
	
	if(area.is_in_group("weapon")) :
		var current_health = health_bar.health
		var random_dammage = 10 + randi() % 3
		health_bar.health = current_health-random_dammage 
		if(health_bar.health <= 0) :
			animated_sprite_2d.play("death")


func _on_animated_sprite_2d_animation_looped():
	if health_bar.health <= 0 :
		queue_free()
