extends Area2D

export(NodePath) onready var hud = get_node(hud)
export(NodePath) onready var target = get_node(target)
var isOverDoor := false
var isLocked := true
var player
var teleportState := 0
var isOpen := false
onready var sprite = $AnimatedSprite


func _physics_process(delta):
	if isOverDoor and Input.is_action_just_pressed("up") and isOpen:
		$AnimatedSprite.play("open")
		player.state = player.States.FROZEN
		player.set_collision_layer_bit(0, false)
		target.isLocked = false
		target.sprite.play("closed")
		teleportState = 0
		$TimerTeleport.start()
		
	elif isOverDoor and Input.is_action_just_pressed("up") and not isOpen:
		$SoundLocked.play()

func _on_Door_body_entered(body):
	player = body
	isOverDoor = true

func _on_Door_body_exited(body):
	isOverDoor = false

func _on_NearDoor_body_entered(body):
	if hud.keys > 0 and isLocked:
		if hud.keys == 1:
			hud.key.texture = load("res://Assets/HUD/hudKey_yellow_empty.png")
		isOpen = true
		target.isOpen = true
		sprite.play("closed")
		target.sprite.play("closed")
		$SoundUnlocked.play()
		hud.keys -= 1
		hud._ready()
		isLocked = false
		target.isLocked = false

func _on_TimerTeleport_timeout():
	match teleportState:
		0:
			player.visible = false
			$SoundTeleport.play()
		1:
			player.position = target.position
			player.get_node("Camera2D").reset_smoothing()
		2:
			target.sprite.play("open")
			sprite.play("closed")
		3:
			player.visible = true
		4:
			target.sprite.play("closed")
			player.state = player.States.FLOOR
			player.set_collision_layer_bit(0, true)
			$TimerTeleport.stop()
	teleportState += 1
