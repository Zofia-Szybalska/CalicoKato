extends KinematicBody2D

var velocity = Vector2()
export var direction = -1 #1 for right, -1 for left
export var detects_cliffs = true
var speed = 50
var isSquashed := false

func _ready():
	if detects_cliffs:
		set_modulate(Color(1.2, 0.5, 1))
	
	if direction == 1:
		$AnimatedSprite.flip_h = true
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floor_checker.enabled = detects_cliffs

func _physics_process(delta):
	if is_on_wall() or not $floor_checker.is_colliding() and detects_cliffs and is_on_floor():
		direction *= -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	elif is_on_wall():
		direction *= -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	velocity.y += 20
	velocity.x = speed * direction
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_top_checker_body_entered(body):
	isSquashed = true
	$sides_checker.set_collision_mask_bit(0, false)
	$sides_checker.set_collision_layer_bit(4, false)
	$top_checker.set_collision_layer_bit(4, false)
	$top_checker.set_collision_mask_bit(0, false)
	$bottom_checker.set_collision_layer_bit(4, false)
	$bottom_checker.set_collision_mask_bit(0, false)
	$AnimatedSprite.play("squashed")
	speed = 0
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(0, false)
	$SoundSquash.play()
	$Timer.start()
	body.bounce()

func _on_sides_checker_body_entered(body):
	if isSquashed or body.position.y > position.y:
		return
	if body.get_collision_layer() == 1:
		body.ouch(position.x, position.y)
	elif body.get_collision_layer() == 32:
		body.queue_free()
		queue_free()

func _on_Timer_timeout():
	queue_free()

func _on_bottom_checker_body_entered(body):
	if body.get_collision_layer() == 1:
		velocity.y = -400
		body.ouch(position.x, position.y)
