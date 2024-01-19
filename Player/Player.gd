extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const FRICTION = 800.0
const ACCELERATION = 800.0
const COYOTE_TIME = 0.1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var isAttacking = false

var facing = 1;

var in_dog_area = false
signal jumped

@onready var animation_player = $AnimationPlayer
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var player = $"."
@onready var jump_sfx = $Jump
	
func _physics_process(delta):
	
	apply_gravity(delta)
	
	handle_jump()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_axis = Input.get_axis("left", "right")
	handle_acceleration(input_axis,delta)
	apply_friction(input_axis,delta)
	update_animations(input_axis)

	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if(just_left_ledge):
		coyote_jump_timer.start(COYOTE_TIME)


func apply_gravity(delta) :
	if not is_on_floor():
		velocity.y += gravity * delta


func handle_jump() :
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("ui_accept") :
			jump_sfx.play()
			if in_dog_area and not AudioServer.is_bus_mute(AudioServer.get_bus_index("SFX")):
				emit_signal("jumped")
			velocity.y = JUMP_VELOCITY
	elif not is_on_floor():
		if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2

func handle_acceleration(input_axis,delta) :
	if input_axis:
		velocity.x = move_toward(velocity.x,SPEED*input_axis,ACCELERATION*delta)

func apply_friction(input_axis,delta) :
	if input_axis == 0 :
		velocity.x = move_toward(velocity.x,0,FRICTION*delta)

func update_animations(input_axis) :
	if(not isAttacking && input_axis != 0 ) :
		if(velocity.x > 0):
			scale.x = scale.y * 1
		elif(velocity.x < 0):
			scale.x = scale.y * -1
		#player.set_scale(Vector2(input_axis,player.scale.y))
	if(isAttacking) :
		animation_player.play("attack")
	elif not is_on_floor() :
		if velocity.y < 0 :
			animation_player.play("jump")
		else :
			animation_player.play("fall")
	elif input_axis != 0 :
		animation_player.play("run")
	else : 
		animation_player.play("idle")
			
func _on_animation_player_animation_finished(anim_name):
	if (anim_name=="attack") :
		isAttacking = false
		#AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)

func _on_dog_player_entered(body):
	if body.get_name() == "Player":
		in_dog_area = true
		print("yes")

func _on_dog_player_exited(body):
	if body.get_name() == "Player":
		in_dog_area = false
		print("no")
