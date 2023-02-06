extends Node

var max_lives = 9
var lives = max_lives
var hud
var coins = 0
var max_coins = 12
var canFire := false
var canJump := false

func lose_live():
	lives -= 1
	hud.load_hearts()
	if lives <= 0:
		get_tree().change_scene("res://Scense/GameOver.tscn")
