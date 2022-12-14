extends PanelContainer

signal finished

var done := false
var carrots_done := false
onready var carrots = $VBoxContainer/MarginContainer/Carrots
onready var max_score = $VBoxContainer/MarginContainer/Carrots/MaxScore

func _ready() -> void:
	$AnimationPlayer.play("popup")
	$GameWin.play()
	yield($GameWin, "finished")
	done = true
	if carrots_done:
		emit_signal("finished")
	
func _unhandled_input(event: InputEvent) -> void:
	if done and Input.is_action_just_pressed("ui_accept"):
		Globals.get_world().restart()
	

func _on_animation_finished(anim_name: String) -> void:
	var full_color = Color("#d25017")
	var is_max_score = Globals.get_world().is_max_score()
	if anim_name=="popup":
		for i in range(Globals.get_world().score):
			var carrot:TextureRect = TextureRect.new()
			carrot.texture = texture		
			carrots.add_child(carrot)
			#yield(get_tree(), "idle_frame")
			yield(get_tree().create_timer(.1), "timeout")
		if is_max_score:
			carrots.move_child(max_score,carrots.get_child_count()-1)			
			max_score.get_node("MaxScoreLabel").modulate.a=0
			max_score.show()
		$VBoxContainer/Continue.visible=true
		carrots_done = true
		if done:
			emit_signal("finished")
		if is_max_score:
			var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)		
			tween.tween_property(max_score.get_node("MaxScoreLabel"),"modulate",full_color,.2)
			$AnimationPlayer.play("MAX_SCORE")
