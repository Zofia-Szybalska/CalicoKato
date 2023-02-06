extends TileMap


func _on_Button_buttonPushed():
	visible = true
	set_collision_layer_bit(1, true)

func _on_Button_buttonBack():
	visible = false
	set_collision_layer_bit(1, false)
