extends Node2D
var playLoop : bool = false
var count : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$PointLight2D.visible=Global.shopOpen
	if Global.shopOpen:
		if Global.powerUpStationInitialSound:
			$InitialSound.play()
			Global.powerUpStationInitialSound=false
			
	
func _on_area_2d_body_entered(body):
	if body.has_method("cat") and Global.shopOpen==true:
		playLoop=false
		$LoopSound.queue_free()
		Global.roundStarted=false
		get_tree().change_scene_to_file("res://scenes/power_up_station_screen.tscn")


func _on_initial_sound_finished():
	print("played")
	playLoop=true
	$LoopSound.play()
	$InitialSound.queue_free()


func _on_loop_sound_finished():
	if playLoop:
		$LoopSound.play()
