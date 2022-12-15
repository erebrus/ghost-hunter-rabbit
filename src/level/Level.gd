extends Node2D


const GameOverScene:PackedScene = preload("res://src/ui/GameOverOverlay.tscn")
#const GameWinScene:PackedScene = preload("res://src/ui/GameWinOverlay.tscn")

var state:int = Globals.WorldState.MATERIAL

var paused:bool = false
#onready var tilemaps=$Tilemaps
var lost:bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


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

	
