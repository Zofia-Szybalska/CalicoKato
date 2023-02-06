extends Area2D

export(NodePath) onready var hud = get_node(hud)

func _on_Key_body_entered(body):
	visible = false
	set_collision_mask_bit(0, false)
	$SoundKey.play()
	hud.key.texture = load("res://Assets/HUD/hudKey_yellow.png")
	hud.keys += 1
	hud._ready()


func _on_SoundKey_finished():
	queue_free()
