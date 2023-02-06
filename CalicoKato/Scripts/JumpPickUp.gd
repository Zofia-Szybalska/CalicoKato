extends Area2D


func _ready():
	$AnimationPlayer.play("idle")
	Global.canFire = true

func _on_JumpPickUp_body_entered(body):
	Global.canJump = true
	set_collision_mask_bit(0, false)
	$AnimationPlayer.play("picked_up")
	$SoundPickedUp.play()
	$CPUParticles2D.emitting = true
	$Label.visible = true
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
