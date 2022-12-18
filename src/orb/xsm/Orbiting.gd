tool
extends State

var player
export(Vector2) var orbit_range:Vector2 = Vector2(96,24)
export(float) var speed:float = 3
export(float) var max_accel=5

var max_light_energy:float
var max_hsv:float
#
var t:float = 0
var velocity:Vector2 = Vector2.ZERO

func get_orbit_center():
	return player.global_position+Vector2(0, -75)
	
# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	player = Globals.get_player()
	owner.light.enabled=false


# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	t+=_delta*speed
	var x=cos(t+owner.offset) * orbit_range.x
	var y=sin(t+owner.offset) * orbit_range.y
	owner.z_index=round(sin(t+owner.offset))
	var target_position = get_orbit_center()+Vector2(x,y)
#	var desired_velocity = target_position - owner.global_position
#	velocity = (desired_velocity-velocity).normalized()*min(max_accel,desired_velocity.length())
#	owner.global_position += velocity
#	Logger.info("orbiting %2f(%2f) - %s " % [t, owner.offset, Vector2(x,y)])
	owner.global_position = target_position




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
