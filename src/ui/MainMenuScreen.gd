extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TileMap/Paths/AnimationPlayer.play("default")
	$CanvasLayer/OptionsPanel.connect("darkness_changed", self,"_on_darkness_value_changed")
	_on_darkness_value_changed(Globals.darkness)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Demo":
		$PlatformTileMap/AnimationPlayer.play("DemoCelebration")
	elif anim_name == "DemoCelebration":
		
		$PlatformTileMap/AnimationPlayer.play("RESET")
		yield(get_tree().create_timer(1),"timeout")
		$PlatformTileMap/AnimationPlayer.play("Demo")	


func _on_darkness_value_changed(new_value:float):
	$Darkness.energy = new_value
