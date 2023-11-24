extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale-=Vector2(0.01,0.01)
	if scale.x<=0.01:
		
		queue_free()


