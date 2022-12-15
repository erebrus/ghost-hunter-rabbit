tool
extends StateAnimation

const LOOKOUT_TIMER="lookout_timer"
export(float) var look_time=1

#var done=false


func _on_enter(args) -> void:
	owner.velocity=Vector2.ZERO
	add_timer(LOOKOUT_TIMER,look_time)
	#owner.get_node("AnimationPlayer").play("default")
#	done=false	
#	yield(get_tree().create_timer(look_time),"timeout")
#	done=true
	
func _on_update(_delta: float) -> void:
	if owner.target:
		change_state("HasTarget")
		
func _on_timeout(_name) -> void:
	if _name == LOOKOUT_TIMER:		
		change_state("Patrol")
	
	
