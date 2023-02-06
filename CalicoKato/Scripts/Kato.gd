extends KinematicBody2D

enum States {AIR, FLOOR, LADDER, WALL, FROZEN}
var state = States.AIR
var playerName = ""
var velocity = Vector2(0,0)
var direction = 1
var last_jump_direction = 0
var on_ladder := false
var hurt := 0 
const SPEED = 250
const RUNSPEED = 440
const JUMPFORCE = -1000
const GRAVITY = 35
const FIREBALL = preload("res://Scense/Fireball.tscn")

func _physics_process(delta):
	match state:
		States.AIR:
			if is_on_floor() and velocity.y == 0:
				state = States.FLOOR
				last_jump_direction = 0
				continue
			elif is_near_wall() and Global.canJump:
				state = States.WALL
				continue
			elif should_climb_ladder():
				state = States.LADDER
				continue
			$Sprite.play("Air")
			if Input.is_action_pressed("right"):
				velocity.x = lerp(velocity.x, SPEED, 0.1) if velocity.x < SPEED  else lerp(velocity.x, SPEED, 0.03)
				$Sprite.flip_h = false
			elif Input.is_action_pressed("left"):
				velocity.x = lerp(velocity.x, -SPEED, 0.1) if velocity.x > -SPEED  else lerp(velocity.x, -SPEED, 0.03)
				$Sprite.flip_h = true
			else:
				velocity.x = lerp(velocity.x, 0, 0.2)
			set_direction()
			move_and_fall(false)
			fire()
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
				continue
			elif should_climb_ladder():
				state = States.LADDER
				continue
			if Input.is_action_pressed("right"):
				if Input.is_action_pressed("run"):
					$Sprite.set_speed_scale(1.8)
					velocity.x = lerp(velocity.x, RUNSPEED, 0.1)
				else:
					$Sprite.set_speed_scale(1.0)
					velocity.x = lerp(velocity.x, SPEED, 0.1)
				$Sprite.play("Walk")
				$Sprite.flip_h = false
			elif Input.is_action_pressed("left"):
				if Input.is_action_pressed("run"):
					$Sprite.set_speed_scale(1.8)
					velocity.x = lerp(velocity.x, -RUNSPEED, 0.1)
				else:
					$Sprite.set_speed_scale(1.0)
					velocity.x = lerp(velocity.x, -SPEED, 0.1)
				$Sprite.play("Walk")
				$Sprite.flip_h = true
			else:
				$Sprite.play("Idle")
				velocity.x = lerp(velocity.x, 0, 0.2)
			
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMPFORCE
				$SoundJump.play()
				state = States.AIR
			set_direction()
			move_and_fall(false)
			fire()
		States.LADDER:
			if not on_ladder:
				state = States.AIR
				continue
			elif is_on_floor() and Input.is_action_pressed("down") and velocity.y == 0:
				state = States.FLOOR
				Input.action_release("down")
				Input.action_release("up")
				continue
			elif Input.is_action_just_pressed("jump"):
				Input.action_release("down")
				Input.action_release("up")
				velocity.y = JUMPFORCE * 0.7
				state = States.AIR
				continue
			
			if Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("right")or Input.is_action_pressed("left"):
				$Sprite.play("Climb")
			else:
				$Sprite.stop()
			
			if Input.is_action_pressed("up"):
				velocity.y = -SPEED
			elif Input.is_action_pressed("down"):
				velocity.y = SPEED
			else:
				velocity.y = lerp(velocity.y, 0, 0.3)
			
			if Input.is_action_pressed("left"):
				$Sprite.flip_h = true
				velocity.x = -SPEED/5
			elif Input.is_action_pressed("right"):
				$Sprite.flip_h = false
				velocity.x = SPEED/5
			else:
				velocity.x = lerp(velocity.x, 0, 0.3)
			
			velocity = move_and_slide(velocity, Vector2.UP)
		States.WALL:
			if is_on_floor():
				state = States.FLOOR
				last_jump_direction = 0
				continue
			elif not is_near_wall():
				state = States.AIR
				continue
			$Sprite.play("Wall")
			#do I want this down here? 
			if direction != last_jump_direction and Input.is_action_pressed("jump") and ((Input.is_action_pressed("left") and direction == 1) or (Input.is_action_pressed("right") and direction == -1)):
				last_jump_direction = direction
				velocity.x = 450 * -direction
				velocity.y = JUMPFORCE * 0.7
				$SoundJump.play()
				state = States.AIR
			if Input.is_action_pressed("right"):
				if Input.is_action_pressed("run"):
					$Sprite.set_speed_scale(1.8)
					velocity.x = lerp(velocity.x, RUNSPEED, 0.1)
				else:
					$Sprite.set_speed_scale(1.0)
					velocity.x = lerp(velocity.x, SPEED, 0.1)
				$Sprite.flip_h = false
			elif Input.is_action_pressed("left"):
				if Input.is_action_pressed("run"):
					$Sprite.set_speed_scale(1.8)
					velocity.x = lerp(velocity.x, -RUNSPEED, 0.1)
				else:
					$Sprite.set_speed_scale(1.0)
					velocity.x = lerp(velocity.x, -SPEED, 0.1)
				$Sprite.flip_h = true
			move_and_fall(true)
		States.FROZEN:
			$Sprite.play("Idle")
			velocity.x = 0
			velocity.y = lerp(velocity.y, GRAVITY, 0.1)
			move_and_fall(false)
			pass

func should_climb_ladder() -> bool:
	return on_ladder and (Input.is_action_pressed("up") or Input.is_action_pressed("down"))

func move_and_fall(slow_fall: bool):
	velocity.y = velocity.y + GRAVITY
	if slow_fall:
		velocity.y = clamp(velocity.y, JUMPFORCE, 200)
	velocity = move_and_slide(velocity, Vector2.UP)

func fire():
	
	if Input.is_action_just_pressed("fire") and not is_near_wall() and hurt == 0 and Global.canFire:
		var f = FIREBALL.instance()
		f.direction = direction
		get_parent().add_child(f)
		f.position.x = position.x + 25 * direction
		f.position.y = position.y

func set_direction():
	direction = -1 if $Sprite.flip_h else 1
	$Wallchecker.rotation_degrees = -90 * direction

func is_near_wall():
	return $Wallchecker.is_colliding() and not $Wallchecker.get_collider().is_in_group("one_way")

func bounce():
	velocity.y = JUMPFORCE * 0.7

func ouch(var enemyposx, var enemyposy):
	Global.lose_live()
	set_collision_layer_bit(0,false)
	$SidesChecker.set_collision_mask_bit(7, false)
	velocity.y = JUMPFORCE * 0.5
	
	if position.y > enemyposy:
		velocity.y = 0
	elif position.x < enemyposx:
		velocity.x = -800
	elif position.x > enemyposx:
		velocity.x = 800
	
	Input.action_release("left")
	Input.action_release("right")
	
	set_modulate(Color(10, 10, 10, 0.9))
	hurt = 15
	$Timer.start()

func _on_FallZone_body_entered(body):
	Global.lose_live()
	var sceneName = get_tree().get_current_scene().get_name()
	if sceneName == "Level2":
		Global.canFire = false
	if sceneName == "Level3":
		Global.canJump = false
	if Global.lives >= 1:
		get_tree().reload_current_scene()

func _on_Timer_timeout():
	hurt -= 1
	if hurt == 0:
		$Timer.stop()
		set_modulate(Color(1,1,1,1))
		set_collision_layer_bit(0,true)
		$SidesChecker.set_collision_mask_bit(7, true)
	else:
		set_modulate(Color(10, 10, 10, 0.9) if hurt%2 == 0 else Color(1,0.3,0.3,0.7))

func _on_LadderChecker_body_entered(body):
	on_ladder = true

func _on_LadderChecker_body_exited(body):
	on_ladder = false

func _on_Secret_body_entered(body):
	$Camera2D.limit_left -= 64*6

func _on_Secret_body_exited(body):
	$Camera2D.limit_left += 64*6

func _on_HiddenSecret_body_entered(body):
	$Camera2D.limit_left -= 64*4

func _on_HiddenSecret_body_exited(body):
	$Camera2D.limit_left += 64*4

func _on_BossWall_body_entered(body):
	ouch(body.position.x, body.position.y)

func _on_SidesChecker_body_entered(body):
	set_collision_layer_bit(0,false)
	ouch(body.position.x, body.position.y)
	body.queue_free()
