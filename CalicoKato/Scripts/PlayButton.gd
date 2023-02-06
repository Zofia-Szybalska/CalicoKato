extends Button


func _on_PlayButton_pressed():
	Global.lives = Global.max_lives
	Global.coins = 0
	Global.canFire = false
	Global.canJump = false
	get_tree().change_scene("res://Scense/Level1.tscn")
