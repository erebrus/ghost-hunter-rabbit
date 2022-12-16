tool
extends StateAnimation

export(float) var max_change_duration:float = 1.0
export(float) var stop_range:float=60
export(float) var attack_range:float=90
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This additionnal callback allows you to act at the end
# of an animation (after the nb of times it should play)
# If looping, is called after each loop
func _on_anim_finished(_name: String) -> void:
	pass


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	Logger.info("%s - entered state %s" % [owner.name, name])
	add_timer("Charge", max_change_duration)

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	if not owner.target:
		return
	var direction = owner.get_facing_direction()	
	var dist = owner.target.global_position.distance_to(owner.global_position)
	var facing_enemy = sign(owner.target.global_position.x - owner.global_position.x) == sign(direction.x)
		
	if owner.on_target():# and owner.can_attack:
		change_state("Attack")
		return			
	if not facing_enemy:
		direction = -owner.get_facing_direction()		
	if dist < stop_range and facing_enemy:
		owner.desired_velocity = Vector2.ZERO
		if owner.sprite.animation!="idle":
			play("Idle")
	else:
		var real_direction_to_target = (owner.target.global_position - owner.global_position).normalized()
		owner.desired_velocity=real_direction_to_target * owner.charge_speed
		if owner.sprite.animation!="run":
			play("Run")

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
	if _name == "Charge":
		change_state("MoveToHoverPoint")
