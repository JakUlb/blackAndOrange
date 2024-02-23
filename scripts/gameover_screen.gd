extends Control

var format_string_stats ="%s: %s"
var format_string_waves_survived ="%s: %s"
# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/Kills.text= format_string_stats % ["ENEMIES KILLED",Global.killCounter]
	$MarginContainer/VBoxContainer/Waves.text= format_string_stats % ["WAVES CLEARED",Global.waveCounter]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_restart_pressed():
	resetGlobal()
	self.queue_free()
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	
func resetGlobal():
	Global.cat_attacking = false
	Global.cat_attack_damage = 10
	Global.wave_cleared = true
	Global.speed = 400
	Global.health = 100
	Global.max_health = null
	Global.attackCooldown = 0.5
	Global.healthDropAmount=10
	Global.killCounter= 0
	Global.waveCounter= 1
	Global.showWaveBanner=true
	
	
