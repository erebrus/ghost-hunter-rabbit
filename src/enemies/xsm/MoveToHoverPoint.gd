tool
extends StateAnimation
const ARRIVAL_DISTANCE=15
const MIN_HOVER_DIST= 175
const MAX_HOVER_DIST= 275

var hover_point:Vector2
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
	determine_hover_point()


# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	
	
	var dist = hover_point.distance_to(owner.global_position)
	if dist < ARRIVAL_DISTANCE:
		change_state("Hover")
		return
		
	var direction = owner.get_facing_direction()	
	var facing_origin = sign(hover_point.x - owner.global_position.x) == sign(direction.x)
	

	if not facing_origin:
		direction = -owner.get_facing_direction()		
	var real_direction_to_origin = (hover_point - owner.global_position).normalized()
	owner.velocity=real_direction_to_origin * owner.engage_speed


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

func determine_hover_point() -> void:
	var dist = RNGTools.randi_range(MIN_HOVER_DIST, MAX_HOVER_DIST)
	var x = RNGTools.randi_range(50, owner.DETECTION_RADIUS*.85)
	if owner.target.global_position.x > owner.global_position.x:
		x = -x
	var angle = asin(abs(x)/dist)
	var y = -abs(cos(angle)*dist)
	hover_point = owner.target.global_position + Vector2(x, y)
	Logger.info("%s set hover point %s (target: %s)" % [owner.name, hover_point, owner.target.global_position])
	
