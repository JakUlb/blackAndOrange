extends Node
var ludwig = preload("res://scenes/Ludwig.tscn")
var ronny = preload("res://scenes/cat.tscn")
var enemyScene = preload("res://scenes/enemy.tscn")
var gameOverScreen = preload("res://scenes/gameover_screen.tscn").instantiate()
var playSound = false
func _ready():
	spawn_cat()
	Global.shopOpen=false
	Global.wave_cleared=false
	$RoundStart.start(3.0)
	$AudioStreamPlayerCountDownSound.play()
	$CountDownSoundTimer.start(1.0)
	
func _process(delta):
	updateWaveCounter()
	if Global.wave_cleared==true:
		Global.shopOpen=true
	if !$RoundStart.is_stopped():
		$HUD/CanvasLayer/CountDown.visible=true
		$HUD/CanvasLayer/CountDown.text= "%s" %int($RoundStart.get_time_left())
	else:
		$CountDownSoundTimer.stop()
	if Global.health <=0:
		gameover()
		
		
func spawn_cat():
	var selectedCat
	if Global.chosen_cat==0:
		selectedCat=ronny
	else:
		selectedCat=ludwig
	var instance = selectedCat.instantiate()
	if Global.chosen_cat==0:
#(health, speed, attackCooldown,attackDamage,knockBackPower)
		instance.initialize(130,200,1,100,70)
	else:
		instance.initialize(100,300,0.25,30,40)
	var worldNode = $world
	var baseCat = $world/Cat
	worldNode.remove_child(baseCat)
	baseCat.queue_free()
	worldNode.add_child(instance)
	instance.start($StartPosition.position)
	
func spawn_enemy():
	var spawnAmount= 10*(Global.waveCounter/2)
	var i = 0
	while i <= spawnAmount:
		var enemy = enemyScene.instantiate()
		enemy.position = Vector2(947,-66)
		add_child(enemy)
		i+=1

func updateWaveCounter():
	if get_tree().get_nodes_in_group("enemies").size() == 0 && Global.wave_cleared==false:
		Global.wave_cleared=true
		Global.waveCounter+=1

func gameover():
	self.queue_free()
	get_tree().root.add_child(gameOverScreen)


func _on_round_start_timeout():
	Global.showWaveBanner=true
	Global.roundStarted=true
	$HUD/CanvasLayer/CountDown.visible=false
	spawn_enemy()


func _on_count_down_sound_timer_timeout():
	$AudioStreamPlayerCountDownSound.play()
