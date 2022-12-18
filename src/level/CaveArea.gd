extends Node2D


export(bool) var disable_enemies :=  false
# Called when the node enters the scene tree for the first time.
func _ready():
	if disable_enemies:
		while $Enemies.get_child_count() != 0:
			$Enemies.remove_child($Enemies.get_child(0))



func _on_Timer_timeout():
	$Tint.visible=!$Tint.visible
#	$Fog.visible=!$Fog.visible
