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
var Xorigin
var Yorigin
var otherFish =[]
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("fish")
	if(is_instance_valid($"../..")):
		Player  = $"../..".get_node("Player")
		hamecon = Player.get_node("fishingaction")

	
func init(x,y):
	Xorigin = x
	Yorigin = y
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_instance_valid($"../..")):
		getOtherFish()
		
		if hamecon.isFishing and not isAttract and not fishOnHook:
			var my_random_number = rng.randf_range(-1000.0, 1000.0)
			if int(my_random_number) == 0 and verifNoOtherFish():
				goToHook()
		elif isAttract and hamecon.isFishing and not fishOnHook:
			translate(directionToHook.normalized()/2)
		if not fishOnHook and not isAttract:
			if(int(position.y) != int(Yorigin)):
				var directionX = Xorigin-position.x
				var directionY = Yorigin-position.y
				var directionVec = Vector2(directionX,directionY)
				translate((directionVec).normalized()/2)
				rotation = atan2(directionY,directionX)
				if directionVec.dot(directionToHook)<0:
					#print(directionVec)
					scale.y = -1
			else:
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
	
func getOtherFish():
	otherFish = get_tree().get_nodes_in_group("fish")

func verifNoOtherFish():
	getOtherFish()
	var numberFishAttrac = 0
	for i in otherFish:
		if i.isAttract:
			numberFishAttrac +=1
			
	return numberFishAttrac<1

func die():
	if fishOnHook:
		queue_free()

func _on_area_2d_area_entered(area):
	if(area.name == "hook"):
		fishOnHook = true
		hamecon.startCooldownPeche()


func _on_area_2d_area_exited(area):
	if(area.name == "hookCoolDown"):
		hamecon.endPeche()



