extends RayCast2D

export(float) var max_length:float=250
export(float) var cast_speed:float=750
export(float) var growth_time:float=.5
export(float) var length_fluctuation:float=.05

export(float) var dps:float=50

onready var line:Line2D = $Line
onready var line_width = line.width
onready var end = $end
onready var sfx_buzz = $Buzz
onready var sfx_hit = $Hitting
onready var beam_particles = $BeamParticles

var offset_value=0
var is_casting:bool = false setget set_is_casting


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set_physics_process(false)
	line.points[1]=Vector2.ZERO
	
func _physics_process(delta: float) -> void:
	offset_value += delta*3
	while offset_value > PI:
		offset_value -= PI
		
	var actual_max_length = max_length + sin(offset_value) * max_length * length_fluctuation
	if is_casting:
		cast_to = (cast_to + Vector2.RIGHT * cast_speed *2 *delta).clamped(actual_max_length+5)
	else:
		sfx_hit.playing=false
		cast_to = (cast_to - Vector2.RIGHT * cast_speed *delta).clamped(actual_max_length+5)
		if cast_to.x<0:
			cast_to=Vector2.ZERO
	cast_beam(delta*dps)
	
func set_is_casting(cast:bool)-> void :
	is_casting = cast	
	sfx_buzz.playing=is_casting
	
	if is_casting:
		cast_to = Vector2.ZERO
		line.points[1]= cast_to
		appear()
	else:		
		disappear()
		
	beam_particles.emitting = is_casting

	
func cast_beam(dmg:float ) -> void:
	var cast_point := cast_to
	
	force_raycast_update()
	
	if is_colliding():
		if not sfx_hit.playing:
			sfx_hit.play()
		cast_point = to_local(get_collision_point())
		end.position=cast_point-Vector2(10,0)
		end.visible=true
		var target = get_collider()
		if target.get_parent().has_method("hit_by_beam"):
			target.get_parent().hit_by_beam(dmg)
	else:
		end.visible=false
		sfx_hit.playing=false
	line.points[1]= cast_point
	beam_particles.position = cast_point *.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * .5

func appear() -> void:
	pass

	
func disappear() -> void:
	pass
	#tween.tween_property(line,"width", 0, growth_time)
	
	
