extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const FRICTION = 800.0
const ACCELERATION = 800.0
const COYOTE_TIME = 0.1

var canFishing = false

var canMove = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer


func _physics_process(delta):
	
	apply_gravity(delta)
	var input_axis = Input.get_axis("left", "right")
	handle_jump()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions
	handle_acceleration(input_axis,delta)
	apply_friction(input_axis,delta)
	
	if canMove:
		move_and_slide()
		
	update_animations(input_axis)

	var was_on_floor = is_on_floor()
	
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if(just_left_ledge):
		coyote_jump_timer.start(COYOTE_TIME)


func apply_gravity(delta) :
	if not is_on_floor():
		velocity.y += gravity * delta


func handle_jump() :
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump") :
			velocity.y = JUMP_VELOCITY
	elif not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2

func handle_acceleration(input_axis,delta) :
	if input_axis:
		velocity.x = move_toward(velocity.x,SPEED*input_axis,ACCELERATION*delta)

func apply_friction(input_axis,delta) :
	if input_axis == 0 :
		velocity.x = move_toward(velocity.x,0,FRICTION*delta)

func update_animations(input_axis) :
	if input_axis != 0 :
		animated_sprite_2d.flip_h = input_axis < 0
		animated_sprite_2d.play("run")
	else :
		animated_sprite_2d.play("idle")
		
	if not is_on_floor() :
		if velocity.y < 0 :
			animated_sprite_2d.play("jump")
		else :
			animated_sprite_2d.play("falling")


func _on_fishing_area_body_entered(body):
	if(body.name == "Player"):
		canFishing = true


func _on_fishing_area_body_exited(body):
	if(body.name == "Player"):
		canFishing = false
