extends Control

var format_string_healthBar= "%s/%s"
var format_string_waveBanner ="%s %s"
var format_string_waveCount ="%s %s"
var format_string_killCount ="%s %s"
var wave_tween : Tween
var waveBanner_font_size=100
var playStartSound = true

# Called when the node enters the scene tree for the first time.
func _ready():
	update_health()
	update_killcounter()
	update_wavecounter()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_health()
	update_killcounter()
	update_wavecounter()
	if Global.showWaveBanner:
		if playStartSound:
			$AudioStreamPlayerStartSound.play()
		waveBanner_font_size+=5
		$CanvasLayer/WaveBanner.text = format_string_waveBanner % ["WAVE",Global.waveCounter]
		$CanvasLayer/WaveBanner.visible=true
		if waveBanner_font_size <= 500 and $CanvasLayer/WaveBanner.visible==true:
			show_waveBanner()
		else:
			waveBanner_font_size=100
			Global.showWaveBanner=false
			$CanvasLayer/WaveBanner.visible=false
		
func update_health():
	if Global.max_health && Global.health:
		$CanvasLayer/HealthBar.max_value = Global.max_health
		$CanvasLayer/HealthBar.value = Global.health
	else:
		$CanvasLayer/HealthBar.max_value = 100
		$CanvasLayer/HealthBar.value = 100
	$CanvasLayer/HealthInfo.text= format_string_healthBar % [Global.health,Global.max_health]

func update_killcounter():
	$CanvasLayer/KillCount.text = format_string_killCount % ["KILLS: ",Global.killCounter]

func update_wavecounter():
	$CanvasLayer/WaveCount.text = format_string_killCount % ["WAVE: ",Global.waveCounter]
	
func show_waveBanner():
	waveBanner_font_size+=5
	$CanvasLayer/WaveBanner.add_theme_font_size_override("font_size",waveBanner_font_size)
	


func _on_audio_stream_player_start_sound_finished():
	playStartSound=false
