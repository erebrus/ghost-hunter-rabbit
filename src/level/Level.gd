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

func _on_game_over():
	get_tree().quit()


func _on_darkness_value_changed(new_value:float):	
	$Foreground/Darkness.energy = new_value

func do_win():
	paused = true
	Globals.get_player().velocity=Vector2.ZERO
#	$HUDLayer.add_child(GameWinScene.instance())
	
func do_end():
	lost=true
	paused = true
	Globals.get_player().velocity=Vector2.ZERO
	print("Game Over. ")	

		
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		#get_tree().change_scene("res://src/ui/MainMenuScreen.tscn")
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		restart()
	
func restart():
	get_tree().change_scene("res://src/level/Level.tscn")

	
