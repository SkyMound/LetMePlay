extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

var max_length = 70
var force = 400
var touching = false
var vector = Vector2.ZERO
var vector_normalized = Vector2.ZERO
var can_move = true
var must_stop = false #à voir avec les autres

var mouse_pos = Vector2()

const FRICTION = 800.0
const offcenter = -13

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = get_local_mouse_position()

func _physics_process(delta):
	
	apply_gravity(delta)
	
	if Input.is_action_pressed("Lmb"):
		vector = -mouse_pos.limit_length(max_length) #le - donne le trait inversé par rapport a la souris
		vector_normalized = vector/max_length
		touching = true # for drawing
	else:
		touching = false
		
	if Input.is_action_just_released("Lmb") and can_move:
		animated_sprite_2d.play("hurt")
		velocity = vector_normalized*force
		
	if is_on_floor() and must_stop:
		animated_sprite_2d.play("idle")
		velocity = Vector2(0,0)
		must_stop = false
		can_move = true
		
	if not is_on_floor():
		can_move = false
		must_stop = true
		
	queue_redraw()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	move_and_slide()
	


func _draw():
	if not touching: return
	
	# Use global coordinates instead of the local ones
	var inv = get_global_transform().inverse()
	draw_set_transform(inv.get_origin(), inv.get_rotation(), inv.get_scale())
	draw_line(global_position + Vector2(0, offcenter), global_position + vector + 2*Vector2(0, offcenter),Color.BLACK)



func apply_gravity(delta) :
	if not is_on_floor():
		velocity.y += gravity * delta
		
func apply_friction(input_axis,delta) :
	if input_axis == 0 :
		velocity.x = move_toward(velocity.x,0,FRICTION*delta)
