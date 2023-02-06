extends TileMap


func _on_Button_buttonPushed():
	visible = true
	set_collision_layer_bit(1, true)

