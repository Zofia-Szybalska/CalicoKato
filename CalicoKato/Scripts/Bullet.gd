extends KinematicBody2D

var velocity = Vector2()
var direction = -1 #1 for right, -1 for left
const SPEED = 500

func _ready():
	velocity.x = SPEED * direction

func _physics_process(delta):
	$Sprite.rotation_degrees += 25 * direction
	
	if is_on_wall():
		queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)

func hit():
	queue_free()
