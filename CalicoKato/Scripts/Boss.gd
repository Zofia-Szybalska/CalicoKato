extends Area2D

const BULLET = preload("res://Scense/Bullet.tscn")
var attackCounter := 0
enum States {ONE, TWO, HURT, CHECKING, WAITING}
var state = States.WAITING
const POSX = -400
var player
var lives = 12
var hurtNow = 0
var hurtCounter = 0
var warning = 0

func _physics_process(delta):
	match state:
		States.CHECKING:
			if $RayCastDown.is_colliding() or $RayCastSecondUp.is_colliding():
				state = States.TWO
				attack_two()
			elif $RayCastUp.is_colliding() or $RayCastSecondDown.is_colliding():
				state = States.ONE
				attack_one()
		States.HURT:
			if lives <= 0:
				get_tree().change_scene("res://Scense/YouWin.tscn")
			pass

func _ready():
	Global.canFire = true
	Global.canJump = true

func hurt():
	if hurtNow < 3:
		$SoundHurt.play()
		lives -= 1
		hurtNow += 1
		set_collision_mask_bit(5, false)
		set_modulate(Color(1,0.3,0.3))

func attack_one():
	attackCounter = 0
	$BeforAttackTimerTimer.start()

func attack_two():
	attackCounter = 0
	$BeforAttackTimerTimer.start()

func _on_Timer_timeout():
	$SoundAttack.play()
	match state:
		States.ONE:
			var b = BULLET.instance()
			add_child(b)
			b.position.x = POSX
			b.position.y = 150
			var b2 = BULLET.instance()
			add_child(b2)
			b2.position.x = POSX
			b2.position.y = -245
		States.TWO:
			var b = BULLET.instance()
			add_child(b)
			b.position.x = POSX
			b.position.y = -47
			var b2 = BULLET.instance()
			add_child(b2)
			b2.position.x = POSX
			b2.position.y = 347
	attackCounter +=1
	if attackCounter == 15:
		state = States.HURT
		set_collision_mask_bit(5, true)
		hurtCounter = 0
		$AnimatedSprite.play("tounge_out")
		$HurtTimer.start()
		$Timer.stop()

func _on_BefriendTimer_timeout():
	if lives == 12:
		get_tree().change_scene("res://Scense/YouWin2.tscn")

func _on_HurtTimer_timeout():
	set_modulate(Color(1,1,1,1))
	set_collision_mask_bit(5, true)
	if hurtCounter == 5:
		$AnimatedSprite.play("tounge_in")
		$HurtTimer.stop()
		set_collision_mask_bit(5, false)
		state = States.CHECKING
		hurtNow = 0
	hurtCounter += 1

func _on_BossActivation_body_entered(body):
	player = body
	$Label.visible = true
	$TileMap.set_collision_mask_bit(0, true)
	$TileMap.set_collision_layer_bit(1, true)
	$AnimationPlayer2.play("close")
	$BossActivation.queue_free()
	player.state = 4
	$AnimationPlayer.play("show")
	$ShowTimer.start()
	$SoundShow.play()

func _on_ShowTimer_timeout():
	player.state = 1
	state = States.CHECKING
	$Label.visible = false
	$BefriendTimer.start()
	$AnimatedSprite.play("tounge_in")

func _on_Boss_body_entered(body):
	if body.get_collision_layer() == 32:
		hurt()

func _on_BeforAttackTimerTimer_timeout():
	match state:
		States.ONE:
			$SpriteA12.set_modulate(Color(1,1,1,1) if warning%2 == 0 else Color(1,1,1,0))
			$SpriteA1.set_modulate(Color(1,1,1,1) if warning%2 == 0 else Color(1,1,1,0))
		States.TWO:
			$SpriteA2.set_modulate(Color(1,1,1,1) if warning%2 == 0 else Color(1,1,1,0))
			$SpriteA22.set_modulate(Color(1,1,1,1) if warning%2 == 0 else Color(1,1,1,0))
	warning += 1
	if warning > 8:
		$SpriteA1.set_modulate(Color(1,1,1,0))
		$SpriteA12.set_modulate(Color(1,1,1,0))
		$SpriteA2.set_modulate(Color(1,1,1,0))
		$SpriteA22.set_modulate(Color(1,1,1,0))
		$BeforAttackTimerTimer.stop()
		$Timer.start()
		warning = 0
