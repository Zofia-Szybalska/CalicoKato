extends Control

func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func _on_EffectsSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Efects"), value)

func _on_MasterSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
