extends "res://src/enemies/Enemy.gd"

onready var sfx_scream = $sfxScream


func do_attack():
	sfx_scream.play()
	yield(get_tree().create_timer(2), "timeout")
	sfx_scream.stop()
	
	
