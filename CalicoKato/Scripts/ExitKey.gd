extends Area2D

export(NodePath) onready var hud = get_node(hud)

func _on_ExitKey_body_entered(body):
	visible = false
	set_collision_mask_bit(0, false)
	$SoundKey.play()
	hud.exitKey.texture = load("res://Assets/HUD/hudKey_green.png")
	hud.hasExitKey = true

func _on_SoundKey_finished():
	queue_free()
