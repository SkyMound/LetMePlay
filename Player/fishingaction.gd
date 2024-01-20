extends Sprite2D
@onready var player = $".."
@onready var lake = player.get_parent().get_node("river")

var target = load("res://Player/fish_target.tscn")
var circle = load("res://Player/cicle.tscn")
var isFishing = false
var instance
var instanceCircle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("fishing"):
		if isFishing and not is_instance_valid(instanceCircle) :
			endPeche()
		elif player.canFishing and not isFishing and not is_instance_valid(instanceCircle):
			startPeche()
		elif(is_instance_valid(instanceCircle)):
			for i in get_tree().get_nodes_in_group("fish"):
				i.die()
			print("Poisson Péché")
			player.set_health(player.health+25)
			endPeche()

func startPeche():
	isFishing = true
	player.canMove=false
	instance = target.instantiate()
	add_child(instance)
	
func endPeche():
	player.canMove = true
	isFishing = false
	for i in get_tree().get_nodes_in_group("fish"):
		i.isAttract = false
		i.fishOnHook = false
	if(is_instance_valid(instance)):
		instance.queue_free()
	if(is_instance_valid(instanceCircle)):
		instanceCircle.queue_free()
	
func startCooldownPeche():
	if(is_instance_valid(instance)):
		instance.queue_free()
	instanceCircle = circle.instantiate()
	add_child(instanceCircle)
