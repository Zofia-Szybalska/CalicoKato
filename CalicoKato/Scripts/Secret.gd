extends Area2D



func _on_Secret_body_entered(body):
	$CPUParticles2D.emitting = false


func _on_Secret_body_exited(body):
	$CPUParticles2D.emitting = true
