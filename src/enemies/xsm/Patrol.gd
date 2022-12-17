tool
extends StateAnimation

export(bool) var engage_directly:bool = false
#

# This additionnal callback allows you to act at the end
# of an animation (after the nb of times it should play)
# If looping, is called after each loop
func _on_anim_finished(_name: String) -> void:
	pass


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	owner.set_trail_type(owner.TrailType.NICE)


# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	var direction = owner.get_facing_direction()	
	if owner.is_must_turn():
		direction = -owner.get_facing_direction()	
	owner.desired_velocity=Vector2(owner.normal_speed,0)*direction


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	if owner.target:
		if engage_directly:
			change_state("Engage")
		else:
			change_state("HasTarget")
	elif owner.is_must_turn():
		change_state("Lookout")


# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	pass


# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args) -> void:
	pass


# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	pass


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass
