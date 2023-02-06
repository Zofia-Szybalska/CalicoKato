extends Area2D

export(NodePath) onready var hud = get_node(hud)
var isOverDoor := false
var isLocked := true
var player
var isOpen := false
var state = 0

func _physics_process(delta):
	if isOverDoor and Input.is_action_just_pressed("up") and isOpen:
		$AnimatedSprite.play("open")
		player.state = player.States.FROZEN
		Global.coins += hud.coins
		$Timer.start()
	elif isOverDoor and Input.is_action_just_pressed("up") and not isOpen:
		$SoundLocked.play()

func _on_NearExit_body_entered(body):
	if hud.hasExitKey and isLocked:
		hud.exitKey.texture = load("res://Assets/HUD/hudKey_green_empty.png")
		isOpen = true
		$AnimatedSprite.play("closed")
		$SoundUnlocked.play()
		hud._ready()
		isLocked = false

func _on_LevelExit_body_entered(body):
	player = body
	isOverDoor = true

func _on_LevelExit_body_exited(body):
	isOverDoor = false


func _on_Timer_timeout():
	match state:
		0:
			player.visible = false
		1:
			var sceneName = get_tree().get_current_scene().get_name()
			if sceneName == "Level1":
				get_tree().change_scene("res://Scense/Level2.tscn")
			elif sceneName == "Level2":
				get_tree().change_scene("res://Scense/Level3.tscn")
			elif sceneName == "Level3":
				get_tree().change_scene("res://Scense/Boss.tscn")
	state += 1
