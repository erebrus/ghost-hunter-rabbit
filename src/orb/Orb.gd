extends Area2D
class_name Orb

signal burst(orb)

enum State {ORBITING, GOING, RETURNING, ATTRACTED, ABSORTION}

var checkpoint
var offset
#export(Vector2) var orbit_range:Vector2
#export(float) var offset:float
#export(float) var speed:float = 3
#export(float) var max_throw_speed:float=1000
#
#export(float) var throw_cost:float = 25
#
#var max_light_energy:float
#var max_hsv:float
#
#var t:float = 0
#var orbiting:bool = true
#var original_position:Vector2
#var target_position:Vector2
#var state = State.ORBITING
#var energy:float = 100
#var velocity:Vector2
#
#var bursting := false
#var available := false
#
#export(bool) var demo_mode:bool = false
#export(Vector2) var demo_source:Vector2
#export(Vector2) var demo_target:Vector2
onready var sprite:Sprite = $Sprite
onready var light:Light2D = $Light2D
onready var player:AnimationPlayer = $Sprite/AnimationPlayer
onready var sfx_burst:AudioStreamPlayer2D = $sfx_burst
onready var explosion = $ExplodingOrb
onready var xsm = $XSM

#func _ready() -> void:
#	max_light_energy = light.energy
#	max_hsv = sprite.modulate.v
#	$Sprite/AnimationPlayer.play("flicker")
##	if demo_mode:		
##		demo_run()
#
#
#func demo_run():
#	#light.scale=Vector2(4, 4)
#	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
#	global_position = demo_source
#	tween.tween_property(self, "global_position", demo_target, 3)
#	tween.tween_property(self, "global_position", demo_source, 3)
#
#	yield(get_tree().create_timer(6), "timeout")
#	demo_run()
#
#
#func update_energy():
#	sprite.modulate.v = max_hsv/2 + energy / 100 *max_hsv/2
#	#light.energy = max_light_energy + energy / 100 * (max_light_energy/2)
#	sprite.scale = Vector2(1,1) / 2 + energy/100 * Vector2(1,1)/2
#
#func _process(delta: float) -> void:	
#	if demo_mode:
#		return	
#
#	t+=delta*speed
#	var x=cos(t+offset) * orbit_range.x
#	var y=sin(t+offset) * orbit_range.y
#	z_index=round(sin(t+offset))
#
#	match state:
#		State.ORBITING:		
#			available=true
#			global_position=Globals.get_player().get_node("Orbs").global_position+Vector2(x,y)
#			#light.scale=Vector2(4, 4)
#
#		State.GOING:
#			available=false
#			var source_pos = original_position
#			#var dist_from_source = source_pos.distance_to(global_position)
#			var dist_to_target = global_position.distance_to(target_position)
#			var dist_source_to_target = source_pos.distance_to(target_position)
#			var ds = dist_to_target/dist_source_to_target
#			var speed = Easing.Cubic.EaseOut(ds, 0, 1, 1)*max_throw_speed*delta			
#			if speed >= dist_to_target or dist_to_target < 15:
#				global_position=target_position
#				state=State.RETURNING
#				Logger.info("%s Returning" % name)
#			else:
#				velocity = (target_position-global_position).normalized()*speed
#				global_position+=velocity
#			#light.scale=Vector2(4, 4)
#			z_index = 0
#
#		State.RETURNING:		
#			var source_pos = (Globals.get_player().get_node("Orbs").global_position + Vector2(x,y))
#			var dist_from_source = source_pos.distance_to(global_position)
#			var dist_to_target = global_position.distance_to(target_position)
#			var dist_source_to_target = source_pos.distance_to(target_position)
#			var ds = dist_from_source/dist_source_to_target
#			var speed = Easing.Cubic.EaseOut(ds, 0, 1, 1)*max_throw_speed*delta
#			if energy <= throw_cost and dist_from_source<125 and not bursting and not available:
#				burst()
#			if dist_from_source< 60:
#				if not available:				
#					available=true
#					energy = clamp(energy - throw_cost, 0, 100)
#					update_energy()
#
#			if speed >= dist_from_source or dist_from_source <  5:
#				global_position=source_pos
#				state=State.ORBITING
#				Logger.trace("%s Orbiting" % name)				
#			else:
#				velocity = (source_pos-global_position).normalized()*speed
#				global_position+=velocity
#			#light.scale=Vector2(4, 4)
#			z_index = 0			
#
#		State.ATTRACTED:
#			move_to_location(target_position)
#
#	if not bursting:		
#		if  energy <= 0:
#			Logger.info("bursting")
#			burst()
#			return	
#	else:				
#		global_position.y+=1
#
#
#func move_to_location(location):
#	var base_speed = velocity.length()
#	var approach_dist=50
#	var capped_dist = clamp(global_position.distance_to(location),0 ,approach_dist)
#	var ds = (approach_dist-capped_dist)/approach_dist
#	var speed = Easing.Cubic.EaseOut(ds, 0, 1, 1)*base_speed
#	speed = clamp(speed,3,100)
#	if speed >= capped_dist or capped_dist <  5:
#		global_position=location
#		state=State.ABSORTION
#		trigger_absortion()
#	else:
#		velocity = (location-global_position).normalized()*speed
#		global_position+=velocity
#
#func burst():
#	bursting = true
#	player.stop(true)
#	emit_signal("burst",self)
#	$Sprite.visible=false
#	explosion.visible=true
#
#	explosion.initialize(sprite.texture)
#	sfx_burst.play()
#
#	yield(get_tree().create_timer(1), "timeout")
#	get_parent().remove_child(self)	
#	call_deferred("queue_free")
#
#func throw(pos:Vector2):
#	original_position = global_position
#	target_position = pos
#
#
#	state=State.GOING	
#	Logger.trace("%s going" % name)
#
#
#func consume_as_fuel(destination:Vector2)->float:
#	target_position = destination
#	state = State.ATTRACTED
#	emit_signal("burst",self)
#	return energy
#
#
#func trigger_absortion():
#	player.play("implode")	
#	yield(get_tree().create_timer(.3), "timeout")
#	get_parent().remove_child(self)	
#	call_deferred("queue_free")
#
#func get_light()->Light2D:
#	return light

func consume():
	xsm.change_state("Consume")
	
	
func do_delivery(_checkpoint):
	checkpoint = _checkpoint
	xsm.change_state("Delivery")
	
func move_to_capture_point():
	z_index=1
	var duration:float = checkpoint.get_capture_position().distance_to(global_position)/250
	var tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", checkpoint.get_capture_position(), duration)
	yield(tween,"finished")
	checkpoint.add_energy(100)
	consume()

func _on_Orb_body_entered(body):
	if not xsm.is_active("Flicker"):
		return
	#if body == Globals.get_player():
		#body.capture_orb()
	xsm.change_state("Orbiting")
	body.add_orb(self)
