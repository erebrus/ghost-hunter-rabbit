extends Node2D

#func _ready():	
#	#yield(get_tree(), "idle_frame")
#	yield(get_tree().create_timer(3), "timeout")
#	dissolve()
	
func dissolve():
	var tween=create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "modulate", Color(1,1,1,0),.5)
	yield(tween,"finished")
	queue_free()
