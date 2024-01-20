extends AnimatedSprite2D

var particles_instance
# Called when the node enters the scene tree for the first time.
func _ready():
	particles_instance = $"..".get_node("starParticles")

	# Rendez le noeud de particules invisible de base
	particles_instance.visible = false

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_star_area_body_entered(body):
	if(body.name=="Player"):
		queue_free()
		particles_instance.visible = true
		particles_instance.emitting = true
