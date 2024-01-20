extends Node2D

@export var fish_y_min = -5.0
@export var fish_y_max = 20.0

var fish = load("res://Entities/fish.tscn")
var instance
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(get_tree().get_nodes_in_group("fish"))<3:
		createFish(rng.randf_range(-30.0, 30.0),rng.randf_range(fish_y_min, fish_y_max))

func createFish(x,y):
	instance = fish.instantiate()
	instance.translate(Vector2(x,y))
	instance.init(x,y)
	add_child(instance)
	pass

func _on_area_2d_body_entered(body):
	if body.name == "Fish":
		if(is_instance_valid($"../..")):
			body.get_node("../../").changeDirection()
