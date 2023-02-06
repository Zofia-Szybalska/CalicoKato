extends Area2D

func _ready():
	$AnimationPlayer.play("hidden")

func _on_HiddenSecret_body_entered(body):
	print(body)
	$AnimationPlayer.play("reavel")

func _on_HiddenSecret_body_exited(body):
	$AnimationPlayer.play("hide")
