extends Node

var last_level:int
var last_checkpoint:int = 0

var win_level = 1

const TutorialScene:String = "res://src/level/TutorialLevel.tscn"
const MainMenuScene:String = "res://src/ui/MainMenuScreen.tscn"
const levels = {
	0:TutorialScene,
	1:"res://src/level/Level.tscn"
}

func load_level(scn:String)->void:
	get_tree().change_scene(scn)
	
func start_tutorial():
	load_level(TutorialScene)
	
func start_game():
	load_level(levels[1])
	
func restart_level():
	load_level(levels[last_level])


func on_level_complete(level):
	last_level = level
	var scn:String = MainMenuScene
	if level==1:
		scn = MainMenuScene #levels[2]
		
	load_level(scn)
	
func is_last_level(level:int):
	return win_level == level

func on_tutorial_done():
	load_level(MainMenuScene)
	
func on_lost():
	load_level(MainMenuScene)
