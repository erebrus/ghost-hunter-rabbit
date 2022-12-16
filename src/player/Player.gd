extends KinematicBody2D

const PlasmaScene = preload("res://src/player/PlasmaShot.tscn")

enum {IDLE, WALK, JUMP, FALL, HURT, DEATH }
const animations = ["default", "walk", "jump", "fall", "hurt", "death"]
 

export(float) var max_speed:float = 200
export(float) var max_accel:float = 40
export(float) var max_deccel:float = 50

export(float) var damage_height:float=700
export(float) var death_height:float=1500

export(float) var th:float = .6
export(float) var h:float = 450
export(float) var v_limit:float =600
export(float) var delta_factor:float = 2
export(float) var damping_speed:float = 300

#export(bool) var jump_inertia:bool = true
export(int) var max_air_jumps = 0
export(float) var inertia_factor:float = .1
export(float) var air_accel_factor:float = .2
export(float) var coyote_time:float = 0.2
export(float) var jump_buffer:float = 0.2
export(float) var hangtime:float = 0.1

export(float) var max_hp=50

var hanging := false
var jump_available := true
var state = IDLE
var velocity:Vector2 = Vector2.ZERO
var air_jump_count:int = 0
var jump_requested:bool = false #for jump buffer
var accept_coyote_jump:bool = false #for coyote time
var landed=false
var accel:float=0
var in_animation:bool = false
var discard_jump:=false
var last_y:float
var last_direction:Vector2
var can_shoot:bool = true

onready var hp:float = max_hp
onready var g:float = 2 * h / (th * th)
onready var v0:float = 2 * h / th
#onready var v0:float = sqrt(2 * h * g)

var dead:bool = false
var firing:bool = false

onready var sprite = $Sprite
onready var collision_shape = $CollisionShape2D
onready var sfx_jump = $Jump
onready var sfx_carrot = $Carrot
onready var beam = $Gun/Sprite/Beam

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Logger.info("Player v0=%f g=%f" % [v0, g])
	last_y=global_position.y
	setup_debug(false)

	sprite.animation=animations[IDLE]
	sprite.play()
		

func _get_actual_g()->float:
	if velocity.y<.1:
		return g
	else:
		return g#*.5
		

func _process(delta: float) -> void:
	
	#if we are in animation, gravity still works
	if in_animation:
		velocity.y += _get_actual_g() * delta * delta_factor
		velocity.x=0
		velocity=move_and_slide(velocity, Vector2.UP)
		return
	
	
	control(delta)
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)		
	velocity.y = clamp(velocity.y, -v0*10, v_limit)
	
	#set coyote timer
	if velocity.y>0.01 and !is_on_floor() and coyote_time>0 and landed:
		accept_coyote_jump=true
		get_tree().create_timer(coyote_time).connect("timeout", self, "reset_coyote_time")
	
	var was_on_floor = is_on_floor()
	var y = global_position.y
	var last_vy=velocity.y
	
	velocity = move_and_slide(velocity, Vector2.UP)
	

	if is_on_floor():
		landed = true

	#just jumped or just landed		
	if !was_on_floor and is_on_floor():
		if abs(velocity.x)<1:
			velocity.x=0
		if jump_requested and jump_available: #jump buffer
			do_jump()
		else:
			do_landing(last_vy)
	elif was_on_floor and not is_on_floor():
		last_y = y
	
#	if abs(velocity.x)<.1:
#		velocity.x=0
		
	if !is_on_floor() and not hanging:
		var was_going_up = velocity.y <=0
		velocity.y += _get_actual_g() * delta * delta_factor
		if was_going_up and velocity.y > 0 and hangtime >0:
#			Logger.info("hanging")
			hanging=true
			get_tree().create_timer(hangtime).connect("timeout", self, "reset_hangtime")
	else:
		air_jump_count = 0
	
	if not in_animation: # we need the check in case we got into animation in control
		update_sprite()

	
func play_celebration():
	$AnimationPlayer.play("Celebrate")
	yield(get_tree().create_timer(1),"timeout")
	$AnimationPlayer.play("Celebrate2")

func do_landing(_last_vy:float):
#	pass
	var dy = global_position.y - last_y
#	Logger.info("v %s - landing delta y:%f ( %f - %f)" % [velocity, dy, global_position.y, last_y])
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", Vector2(1,.9), .15)
	tween.parallel().tween_property(sprite, "position", Vector2(10,-135), .15)
	tween.tween_property(sprite, "scale", Vector2(1,1), .15).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(sprite, "position", Vector2(10,-155), .15).set_ease(Tween.EASE_IN)

#	if velocity.x<.5:
#		Logger.info("correcting")
#		velocity.x=0	
	
func setup_debug(val:bool):
	if val:
		HyperLog.log(self).text("global_position>%0.2f")
		HyperLog.log(self).text("velocity>%0.2f")
		HyperLog.log(self).text("accel>%0.2f")

	else:
		HyperLog.remove_log(self)
		


func update_sprite():
	var prev_state = state

	if is_on_floor():
		if velocity.x==0 and not firing:
			state = IDLE
			sprite.animation=animations[state]
			sprite.stop()
			return
		else:
			state = WALK			
	else:
		if velocity.y>0:
			state = JUMP
		else:
			state = FALL
			
	if firing:
		var target_pos = get_global_mouse_position()
		sprite.flip_h = (target_pos - global_position).x<0
	elif velocity.x != 0:
		sprite.flip_h = velocity.x<0			
	if velocity.x != 0:
		last_direction = Vector2(velocity.x,0).normalized()
	
	
	if prev_state != state:
#		Logger.info("changing anim state from %s to %s" % [prev_state, state])
		sprite.play(animations[state])


func do_jump():
	if jump_available:	
		sfx_jump.play()
		velocity.y=-v0
		jump_available = false
		landed=false
		discard_jump=false
		if !is_on_floor() and not is_in_coyote_time():
			air_jump_count += 1		
			
			
func control(_delta:float) -> void:
	if Globals.get_world().paused:
		return
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	input.y=0
		
	if abs(input.x)<.1 && abs(velocity.x)>.1:		
		var f = 1 if is_on_floor() else inertia_factor
		var tmp_max=min(abs(max_deccel*f),abs(velocity.x))
		accel = -tmp_max if velocity.x>0 else tmp_max
	else:	
		if abs(velocity.x) < 0.1:
			if (input.x >.1 and velocity.x>=0) or (input.x <.1 and velocity.x<=0):
				var f = 1 if is_on_floor() else air_accel_factor 
				accel = +max_accel*f*input.x				
			#elif (input.x >0 and velocity.x<=0) or (input.x <0 and velocity.x>=0) :
			else:											
				var f = 1 if is_on_floor() else air_accel_factor 
				var tmp_max=min(abs(max_deccel*f),abs(velocity.x))
				accel = -tmp_max if velocity.x>0 else tmp_max
				

		else:
			accel = +max_accel*input.x				
			
	velocity.x += accel
	
	if is_on_ceiling() and velocity.y < 0:
		velocity.y = 0
	if is_on_wall():
		velocity.x = 0 
		
		
	if Input.is_action_pressed("jump"):		
		#JUMP
		if is_on_floor() || air_jump_count<max_air_jumps || is_in_coyote_time():
			do_jump() 
			
		else:
			discard_jump=true
					
#		if !is_on_floor(): #BOOST
#			if velocity.y<0:
#				velocity.y -= g * lift_factor * delta * delta_factor
#				jump_available = false
#			else:
#				#jump_requested=true
#				get_tree().create_timer(jump_buffer).connect("timeout",self,"reset_jump_buffer")

	if Input.is_action_just_released("jump"):
		jump_available=true
		if velocity.y < 0 and not discard_jump:
			 velocity.y =velocity.y + damping_speed #clamp(velocity.y + damping_speed, velocity.y, 0)
						

#	if Input.is_action_just_pressed("attack"):
#		do_attack1()
	if Input.is_action_pressed("attack2"):
		fire_beam()
	else:
		stop_beam()

	
func is_in_coyote_time()	:
	return accept_coyote_jump

func reset_coyote_time():
	accept_coyote_jump=false
		
func reset_jump_buffer():
	jump_requested=false

func reset_hangtime():
	hanging = false
	
func take_damage(source, damage, do_ouch=true):
	if dead:
		return
#	get_tree().quit()
	sprite.flip_h = source.global_position < global_position
	hp = clamp(hp-damage, 0, max_hp)
	in_animation=true
	if hp == 0:
		dead = true		
		sprite.play("death")
		if do_ouch:
			$Hurt.play()
	else:
		sprite.play("hurt")
		if do_ouch:
			$Hurt.play()
	if do_ouch:
		yield(sprite,"animation_finished")	
	else:
		yield(get_tree().create_timer(1), "timeout")
	if dead:
		yield(get_tree().create_timer(1), "timeout")
		Logger.info("player died: %s" % sprite.animation)	
		#Globals.get_world().do_end()		
		get_tree().quit()
	else:
		in_animation=false


#func do_attack1():
#	if not can_shoot:
#		return
#
#	var bullet = PlasmaScene.instance()
#	bullet.global_position = $Muzzle.global_position
#	bullet.init(last_direction)
#	get_parent().add_child(bullet)
#	can_shoot=false
#	$ReloadTimer.start()
	
func fire_beam():
	var gun = $Gun/Sprite
	if not beam.is_casting:
		beam.set_is_casting(true)
	var target_pos = get_global_mouse_position()
	var angle = (target_pos - gun.global_position).angle()
	if not sprite.flip_h:
		angle = clamp(angle, -PI/3, PI/4)
	else:
		if angle > -2*PI/3 and angle < 0:
			angle = -2*PI/3
		elif angle < 3*PI/4 and angle >0:
			angle = 3*PI/4
	
	gun.rotation = angle
	if not sprite.flip_h:
		$Gun/Sprite.flip_v= false	
		if sign(beam.position.y) <0:
			 beam.position.y *= -1
	else:		
		$Gun/Sprite.flip_v= true	
		if sign(beam.position.y) >0:
			 beam.position.y *= -1
		
#	beam.rotation = (target_pos - global_position).angle()
		#gun rotation
	firing = true
	$Gun/Sprite.visible=true
	
		
func stop_beam():
	if beam.is_casting:
		beam.set_is_casting(false)
	firing = false
	$Gun/Sprite.visible=false


func _on_ReloadTimer_timeout():
	can_shoot = true
