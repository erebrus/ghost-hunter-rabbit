extends RayCast2D

export(float) var max_length:float=250
export(float) var cast_speed:float=750
export(float) var growth_time:float=.5
export(float) var length_fluctuation:float=.05

export(float) var dps:float=50

onready var line:Line2D = $Line
onready var line_width = line.width
onready var casting_particles = $CastingParticles
onready var collision_particles = $CollisionParticles
onready var beam_particles = $BeamParticles
onready var sfx_buzz = $Buzz
onready var sfx_hit = $Hitting

var offset_value=0
var is_casting:bool = false setget set_is_casting
var tween:SceneTreeTween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set_physics_process(false)
	tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	line.points[1]=Vector2.ZERO
	
func _physics_process(delta: float) -> void:
	offset_value += delta*3
	while offset_value > PI:
		offset_value -= PI
		
	var actual_max_length = max_length + sin(offset_value) * max_length * length_fluctuation
	if is_casting:
		cast_to = (cast_to + Vector2.RIGHT * cast_speed *2 *delta).clamped(actual_max_length)
	else:
		sfx_hit.playing=false
		cast_to = (cast_to - Vector2.RIGHT * cast_speed *delta).clamped(actual_max_length)
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
		
		collision_particles.emitting = false
		disappear()
		
	#set_physics_process(is_casting)
	beam_particles.emitting = is_casting
	casting_particles.emitting = is_casting
	
func cast_beam(dmg:float ) -> void:
	var cast_point := cast_to
	
	force_raycast_update()
	collision_particles.emitting = is_colliding()
	
	if is_colliding():
		if not sfx_hit.playing:
			sfx_hit.play()
		cast_point = to_local(get_collision_point())
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = cast_point
		var target = get_collider()
		if target.get_parent().has_method("hit_by_beam"):
			target.get_parent().hit_by_beam(dmg)
	else:
		sfx_hit.playing=false
	line.points[1]= cast_point
	beam_particles.position = cast_point *.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * .5

func appear() -> void:
	pass
#	if tween.is_running():
#		tween.stop()
	#var tween := create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
#	var bounce_position=global_position+(direction*-attack_bounce_distance)
#	tween.tween_property(self, "global_position",bounce_position,.25)
#	get_tree().create_timer(.25).connect("timeout",self, "stop_attack")
	#tween.tween_property(line,"width", 10, growth_time*2)
	#tween.play()
	
func disappear() -> void:
#	if tween.is_running():
#		tween.stop()
	
	tween.tween_property(line,"width", 0, growth_time)
	#tween.play()
	
	
