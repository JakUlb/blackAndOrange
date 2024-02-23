extends Control

var isStartDisabled=true
var ronny = preload("res://scenes/cat.tscn")
var ludwigBook : Control
var ronnyBook: Control
func _ready():
	$VBoxContainer/MarginContainer/StartButton.disabled=true
	ludwigBook=get_node("LudwigBook")
	ronnyBook=get_node("RonnyBook")
	ludwigBook.connect("ludwig_exit_button_pressed",_on_ludwig_exit_button_pressed)
	ronnyBook.connect("ronny_exit_button_pressed",_on_ronny_exit_button_pressed)
	ludwigBook.visible=false
	ronnyBook.visible=false
func _process(delta):
	if not isStartDisabled:
		$VBoxContainer/MarginContainer/StartButton.disabled=false
		

func _on_ludwig_button_pressed():
	Global.chosen_cat=Global.catType.LUDWIG
	isStartDisabled=false


func _on_ronny_button_pressed():
	Global.chosen_cat=Global.catType.RONNY
	isStartDisabled=false
	


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")



func _on_ludwig_info_button_pressed():
	$LudwigBook.visible=true

func _on_ludwig_exit_button_pressed():
	$LudwigBook.visible=false



func _on_ronny_info_button_pressed():
	$RonnyBook.visible=true
	
func _on_ronny_exit_button_pressed():
	$RonnyBook.visible=false

func _on_background_music_finished():
	$BackgroundMusic.play()
