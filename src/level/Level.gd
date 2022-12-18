extends Node2D


const GameOverScene:PackedScene = preload("res://src/ui/GameOverOverlay.tscn")
#const GameWinScene:PackedScene = preload("res://src/ui/GameWinOverlay.tscn")



var paused:bool = false
#onready var tilemaps=$Tilemaps
var lost:bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("game_over",self, "_on_game_over")
	_on_darkness_value_changed(Globals.darkness)
#	Globals.get_player().connect("hp_updated", $HUD, "update_health")
func _on_game_over():
	get_tree().quit()


func _on_darkness_value_changed(new_value:float):	
	$Foreground/Darkness.energy = new_value

func do_win():
	paused = true
	$HUDLayer/LevelComplete.visible=true
	
func do_end():
	lost=true
	paused = true
	$HUDLayer/GameOver.visible = true
	Globals.get_player().velocity=Vector2.ZERO
	yield(get_tree().create_timer(3), "timeout")
	LevelManager.on_lost()

		
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://src/ui/MainMenuScreen.tscn")
		
	if Input.is_action_just_pressed("restart"):
		LevelManager.restart_level()
	


	
