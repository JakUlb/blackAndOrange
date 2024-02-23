extends Node2D
var playLoop : bool = false
var playInitialSound : bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$PointLight2D.visible=Global.shopOpen
	if Global.shopOpen:
		if playInitialSound:
			$InitialSound.play()
			
	
func _on_area_2d_body_entered(body):
	if body.has_method("cat") and Global.shopOpen==true:
		playLoop=false
		Global.roundStarted=false
		get_tree().change_scene_to_file("res://power_up_station_screen2.tscn")


func _on_initial_sound_finished():
	playLoop=true
	$LoopSound.play()
	playInitialSound=false


func _on_loop_sound_finished():
	if playLoop:
		$LoopSound.play()
