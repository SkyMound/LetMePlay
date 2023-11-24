extends Node2D

var fish = load("res://Entities/fish.tscn")
var instance
# Called when the node enters the scene tree for the first time.
func _ready():
	createFish(0,0)
	#createFish(10,10)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func createFish(x,y):
	instance = fish.instantiate()
	instance.translate(Vector2(x,y))
	add_child(instance)
	pass
	

func _on_area_2d_body_entered(body):
	if body.name == "Fish":
		body.get_node("../../").changeDirection()
	
