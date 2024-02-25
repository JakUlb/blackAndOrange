extends CharacterBody2D

var screen_size
var speed = 100
var detected = false
var cat = null
var fovMultiplicator = 1.7
var health= 90+Global.waveCounter*10
var player_infov = false
var enemy_attackable = false
var cat_attackable = false
var health_drop_scene = preload("res://scenes/health_drop.tscn")
var trackingRandomPosition = false
var randomPosition 
var isDead : bool = false
var isInvincible: bool = false


func _ready():
	screen_size = get_viewport_rect().size
	initHealthBar()
	$InvincibilityTimer.wait_time=Global.attackCooldown

func _physics_process(delta):
	if detected:
		speed=150
		moveToPosition(cat.position,delta)
	else:
		speed=100
		if not trackingRandomPosition:
			randomPosition=Vector2(randf_range(0,1920),randf_range(0,720))
			trackingRandomPosition=true
		else:
			moveToPosition(randomPosition,delta)
			if abs(position-randomPosition) <= Vector2(2,2):
				trackingRandomPosition=false
		

func _on_fov_body_entered(body):
	cat = body
	$FOV/CollisionShape2D.apply_scale(Vector2(fovMultiplicator,fovMultiplicator))
	detected = true

func _on_fov_body_exited(body):
	cat = null
	$FOV/CollisionShape2D.apply_scale(Vector2(1/fovMultiplicator,1/fovMultiplicator))
	detected = false


func dropItem():
	if randi_range(0,100) < Global.healthDropProbability:
		var health_drop = health_drop_scene.instantiate()
		health_drop.position=(self.position)
		get_parent().add_child(health_drop)

func take_damage():
	if !isInvincible:
		$AudioStreamTakeDamage.play()
		$DamageTakenLabel.text=str(Global.cat_attack_damage*-1)
		$DamageTakenLabel.visible=true
		$DamageTakenTimer.start()
		health -= Global.cat_attack_damage
		knockback()
		updateHealthBar()
		isInvincible=true
		$InvincibilityTimer.start()
	
func knockback():
	var direction = cat.position.direction_to(self.global_position)
	var knockbackAmount = direction*Global.knockBackPower
	global_position += knockbackAmount
			
	
func moveToPosition(inputPosition,delta):
	var direction = (inputPosition - position).normalized()
	velocity=direction*speed
	$AnimatedSprite2D.play("horizontal")
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h=true
	else:
		$AnimatedSprite2D.flip_h=false
	move_and_slide()
	
func updateHealthBar():
	$HealthBar.value=health
	
func initHealthBar():
	$HealthBar.value=health
	$HealthBar.max_value=health
	
func enemy():
	pass
	

func _on_audio_stream_take_damage_finished():
	if health <= 0:
		isDead=true
		dropItem()
		Global.killCounter+=1
		self.queue_free()


func _on_invincibility_timer_timeout():
	isInvincible=false





func _on_damage_taken_timer_timeout():
	$DamageTakenLabel.text=""
	$DamageTakenLabel.visible=false
