extends Button

@export var sound_off : Texture2D
@export var sound_on : Texture2D
	
func _ready():
	self.icon = sound_on

func _toggled(_button_pressed):
	if self.icon == sound_off:
		self.icon = sound_on
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"),false)
	else:
		self.icon = sound_off
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"),true)
