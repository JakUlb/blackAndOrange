extends CharacterBody2D

var screen_size
var enemy_attackable = false
var cat_attackable = false
var invincible = false
var attacking = false
var isAttackCooledDown = true
var claws_player
var animationBaseDuration = 0.2
var hFlip : bool
var vFlip : bool
@export var animationPlayer: AnimationPlayer


func _ready():
	screen_size = get_viewport_rect().size
	claws_player = get_node("Claws/AnimationPlayer")
	animationPlayer.play("move_up")

func _physics_process(delta):
	if !Global.cat_attacking:
		$Claws/Sprite2D/MyHitBox/CollisionShape2D.disabled=true
		$Claws.visible = false
	if Global.roundStarted:
		move(delta)
	enemy_attack()
	

func initialize(health, speed, attackCooldown,attackDamage,knockBackPower):
	if !Global.max_health:
		Global.max_health=health
		Global.health = health
		Global.speed = speed
		Global.attackCooldown = attackCooldown
		Global.cat_attack_damage = attackDamage
		Global.knockBackPower = knockBackPower

#movement

func move(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x =+1
	if Input.is_action_pressed("move_left"):
		velocity.x =-1
	if Input.is_action_pressed("move_up"):
		velocity.y =-1
	if Input.is_action_pressed("move_down"):
		velocity.y =+1
	attack()
	
	if velocity.length() > 0:
		velocity= velocity.normalized() * Global.speed
		play_movement_animation(velocity)
	else:
		animationPlayer.stop()
	
	position += velocity*delta 
	position = position.clamp(Vector2.ZERO,screen_size)
	move_and_slide()
	

func play_movement_animation(velocity):
	$Sprite2D.rotation=0
	if abs(velocity.x) > abs(velocity.y):
		$Sprite2D.rotation=0
		if velocity.x < 0:
			animationPlayer.play("move_left")
		else:
			animationPlayer.play("move_right")
	else:
		$Sprite2D.rotation=0
		if velocity.y > 0:
			animationPlayer.play("move_down")
			if velocity.x != 0:
				if velocity.x < 0:
					$Sprite2D.rotation=45
					$CollisionShape2D2.rotation+=45
				elif velocity.x > 0:
					$Sprite2D.rotation=-45
		else:	
			animationPlayer.play("move_up")	
			if velocity.x != 0:
				if velocity.x < 0:
					$Sprite2D.rotation=-45
				elif velocity.x > 0:
					$Sprite2D.rotation=45

func start(pos):
	position = pos

func cat():
	pass

func attack():
	if Input.is_action_pressed("attack") and isAttackCooledDown :
		Global.cat_attacking = true
		isAttackCooledDown=false
		$Claws.visible = true
		var speed= animationBaseDuration / Global.attackCooldown
		$AttackCooldownTimer.start(Global.attackCooldown)
		claws_player.play("attack",-1,speed)


	
func enemy_attack():
	if cat_attackable and !invincible:
		$AudioStreamCatScream.play()
		Global.health -= 10
		invincible=true
		$InvincibleTimer.start()


func _on_attacksurface_body_entered(body):
	if body.has_method("enemy"):
		cat_attackable=true

func _on_attacksurface_body_exited(body):
	if body.has_method("enemy"):
		cat_attackable=false

func _on_invincible_timer_timeout():
	invincible=false
	velocity=Vector2.ZERO


func _on_attack_cooldown_timer_timeout():
	isAttackCooledDown=true;


