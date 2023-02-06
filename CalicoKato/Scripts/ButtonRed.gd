extends StaticBody2D

# radius 2, hight 26
#0, -19 <- position y

var onButton := false
signal buttonPushed
signal buttonBack

func _physics_process(delta):
	if onButton and Input.is_action_pressed("down"):
		$AnimatedSprite.play("down")
		$AudioStreamPlayer.play()
		$CollisionShapeTop.position.y = -19
		$CollisionShapeTop.shape.radius = 2
		$CollisionShapeTop.shape.height = 26
		$TopChecker.set_collision_mask_bit(0, false)
		emit_signal("buttonPushed")
		$Timer.start()

func _on_TopChecker_body_entered(body):
	onButton = true

func _on_TopChecker_body_exited(body):
	onButton = false


func _on_Timer_timeout():
	$AnimatedSprite.play("up")
	$AudioStreamPlayer.play()
	$CollisionShapeTop.position.y = -33
	$CollisionShapeTop.shape.radius = 5
	$CollisionShapeTop.shape.height = 26
	$TopChecker.set_collision_mask_bit(0, true)
	emit_signal("buttonBack")
