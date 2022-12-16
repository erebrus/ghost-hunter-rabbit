tool
extends "res://src/enemies/xsm/Engage.gd"

export(float) var attack_delay = .5
var can_attack:=true
var triggered_attack:=false

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	Logger.info("%s - entered state %s" % [owner.name, name])
	can_attack=true
	triggered_attack=false
	
	
# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	if not owner.target:
		return
		
	var direction_to_target= Vector2.LEFT * sign(owner.global_position.x - owner.target.global_position.x)
	var target_position = owner.target.global_position - direction_to_target * stop_range
	
#	owner.get_node("Crosshair").global_position=target_position
#	owner.get_node("Crosshair").visible=true
	
	
	var direction = owner.get_facing_direction()	
	var dist = owner.global_position.distance_to(target_position)
	var dist_to_enemy = owner.global_position.distance_to(owner.target.global_position)
	var facing_enemy = sign(owner.target.global_position.x - owner.global_position.x) == sign(direction.x)
	var facing_target_position = sign(target_position.x - owner.global_position.x) == sign(direction.x)		
	
	if not facing_enemy:
		direction = -owner.get_facing_direction()		
	if (dist < 15 or dist_to_enemy < stop_range) and facing_enemy:
		owner.desired_velocity = Vector2.ZERO
		if owner.sprite.animation!="walk":
			play("Walk")
		if not triggered_attack:
			triggered_attack=true
			add_timer("Attack",attack_delay)
		
	else:
		var real_direction_to_target = (target_position - owner.global_position).normalized()
		owner.desired_velocity=real_direction_to_target * owner.engage_speed
		if owner.sprite.animation!="run":
			play("Run")

func target_in_sight()->bool:
	var dist = owner.global_position.distance_to(owner.target.global_position)
	if dist > attack_range:
		return false
	var facing_enemy = sign(owner.target.global_position.x - owner.global_position.x) == sign(owner.get_facing_direction().x)	
	if not facing_enemy:
		return false

	return abs(owner.global_position.y - owner.target.global_position.y) < stop_range


# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args) -> void:
	owner.get_node("Crosshair").visible=false

# Called when any other Timer times out
func _on_timeout(_name) -> void:	
	if _name == "Charge":
#		if target_in_sight() and can_attack:
#			change_state("Attack")
#			can_attack=false
#		else:
			can_attack=false
			change_state("MoveToHoverPoint")
	if _name == "Attack":
		if can_attack:
			can_attack=false
			change_state("Attack")
