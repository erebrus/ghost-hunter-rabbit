extends PanelContainer

signal finished

var done := false


func _ready() -> void:
	$AnimationPlayer.play("popup")
	$GameOver.play()
#	yield($GameOver, "finished")
	

	
func _unhandled_input(event: InputEvent) -> void:
	if done and Input.is_action_just_pressed("ui_accept"):
		Globals.get_world().restart()
	
func _on_animation_finished(anim_name: String) -> void:
	done = true
	$VBoxContainer/Continue.visible=true
	emit_signal("finished")
	
