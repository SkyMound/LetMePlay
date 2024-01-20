extends Button

@onready var player = $"..".get_node("Player")
@onready var health_bar = player.get_node("HealthBar")
@onready var hitBox = player.get_node("CollisionHealth")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	if(is_instance_valid(health_bar)):
		health_bar.queue_free()
		hitBox.queue_free()
	
