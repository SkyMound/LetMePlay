extends Node2D

var right = true
var direction = Vector2(0.5,0)
var isAttract = false
var xHook = 100
var yHook = 100
var directionToHook
var Player
var hamecon
var fishOnHook= false

# Called when the node enters the scene tree for the first time.
func _ready():
	Player  = $"../..".get_node("Player")
	hamecon = Player.get_node("fishingaction")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if hamecon.isFishing and not isAttract and not fishOnHook:
		goToHook()
	elif isAttract and hamecon.isFishing and not fishOnHook:
		translate(directionToHook.normalized()/2)
	elif not fishOnHook:
		isAttract = false
		rotation = 0
		scale.y = 1
		if right:
			translate(direction)
			scale.x = 1
		else:
			translate(direction)
			scale.x = -1

func changeDirection():
	right=not right
	direction = -direction
	
func goToHook():
	var deltaX = hamecon.get_global_position().x-get_global_position().x
	var deltaY = hamecon.get_global_position().y-get_global_position().y
	directionToHook = Vector2(deltaX,deltaY)
	rotation = atan2(deltaY,deltaX)
	scale.x = 1
	if direction.dot(directionToHook)<0 and right or direction.dot(directionToHook)>0 and not right:
		scale.y = -1
	isAttract = true

func _on_area_2d_area_entered(area):
	if(area.name == "hook"):
		fishOnHook = true
		hamecon.startCooldownPeche()

		

