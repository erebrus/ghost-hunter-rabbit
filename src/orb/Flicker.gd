tool
extends StateAnimation

export(float) var oscillation_frequency_factor:float = 5
export(float) var oscillation_range:float = 5
var start_pos:=Vector2.ZERO
var start_seed:float

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	start_seed = randf()
	start_pos=owner.global_position
	owner.get_node("Light2D").enabled=true

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	
	var dsin = sin(OS.get_system_time_msecs()/250.0)
	owner.global_position.y = start_pos.y+ dsin*oscillation_range
#	if owner.name == "Orb":
#		print ("%s - start:%2f - sin %2f - pos.y: %2f" % [owner.name,start_pos.y, dsin, owner.global_position.y])

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
