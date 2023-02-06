extends Area2D


func _on_HiddenArea_body_entered(body):
	$AnimationPlayer.play("reaveal")

func _on_HiddenArea_body_exited(body):
	$AnimationPlayer.play("exited")

func _on_Key_body_entered(body):
	$CPUParticles2D.emitting = false
