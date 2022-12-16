extends KinematicBody2D


const DETECTION_RADIUS:float = 500.0 #TODO set shape radius
signal player_detected
signal under_new_attack
signal start_recovery

export(float) var recovery_rate = 150
export(float) var max_hp:int = 200
export(float) var normal_speed:float = 50
export(float) var engage_speed:float = 200
export(float) var charge_speed:float = 300
export(float) var  max_accel:float =10.0
export(float) var attack_damage:float = 25
export(float) var attack_reload:float = 1

export(float) var detection_radius:float = 500.0



var can_attack:bool = true
var desired_velocity:=Vector2()
var velocity:=Vector2()
var direction:int=0
var target
var can_recover:bool = true

onready var hp:float =max_hp

onready var floor_rc:RayCast2D = $FloorRaycast
onready var front_rc:RayCast2D = $FrontRaycast
onready var sprite:AnimatedSprite = $Sprite
onready var detection_box = $DetectionBox/CollisionShape2D
onready var attack_box = $HurtBox/CollisionShape2D
onready var reload_timer = $ReloadTimer
onready var xsm = $XSM

var dist_to_enemy:float=0
onready var original_position:Vector2 = global_position

func _ready() -> void:
	detection_box.shape = CircleShape2D.new()
	detection_box.shape.radius = detection_radius
#	setup_debug(true)



func get_facing_direction()->Vector2:
#	if velocity.x ==0:
#		return Vector2.ZERO		
#	el
	if sprite.flip_h:
		return Vector2.LEFT
	else:
		return Vector2.RIGHT
	
func is_must_turn()->bool:
	return not floor_rc.is_colliding() or front_rc.is_colliding()


func setup_debug(val:bool):
	if val:
		HyperLog.log(self).text("global_position>%0.2f")
		HyperLog.log(self).text("velocity>%0.2f")
		HyperLog.log(self).text("dist_to_enemy>%0.2f")

	else:
		HyperLog.remove_log(self)
		

func check_direction():
	
	if velocity.x != 0 and sign(get_facing_direction().x) != sign(velocity.x):
		sprite.flip_h = !sprite.flip_h
		front_rc.cast_to.x=-front_rc.cast_to.x
		floor_rc.cast_to.x=-floor_rc.cast_to.x
		detection_box.position.x=-detection_box.position.x

func set_collide_with_platform(val:bool)-> void:
	if $CollisionShape2D:
		$CollisionShape2D.disabled = !val
	$FloorRaycast.enabled = val
	$FrontRaycast.enabled = val


func _process(delta: float) -> void:

	if can_recover and hp != max_hp:		
		hp+=recovery_rate*delta
		hp=clamp(hp, 0, max_hp)
		print("recovering. hp %d" % hp)
	check_direction()
	
	#velocity = velocity.linear_interpolate(desired_velocity, .2)
	
	var delta_velocity = desired_velocity-velocity
	velocity += delta_velocity.normalized()*min(max_accel, delta_velocity.length())
	velocity = move_and_slide(velocity, Vector2.UP)
	dist_to_enemy=-1 if not target else global_position.distance_to(target.global_position)

func _on_ReloadTimer_timeout() -> void:
	can_attack = true
	attack_box.disabled=false

func _on_DetectionBox_body_entered(body: Node) -> void:
	if body == Globals.get_player():
		target = body
		detection_box.shape.radius=detection_radius*3


func _on_DetectionBox_body_exited(body: Node) -> void:
	if body == Globals.get_player():
		target = null
		detection_box.shape.radius=detection_radius
		

func do_attack():
#	if not can_attack:
#		return
#	can_attack=false
	
	if target and attack_box.get_parent().overlaps_body(target):
		target.take_damage(self, attack_damage)
#	attack_box.disabled=true
	reload_timer.start()

func take_damage(source, damage):
	hp = clamp(hp-damage, 0, 30)
	if hp >0:
		xsm.change_state("Hurt")
	else:
		xsm.change_state("Death")

func hit_by_beam(dmg):
	hp -= 1
	hp = clamp(hp, 0, max_hp)
	if can_recover:
		can_recover=false
		emit_signal("under_new_attack")
	$RecoveryTimer.start()
	print("hit by beam. hp %d" % hp)
	
	if hp==0 and not xsm.is_active("Hurt"):
		xsm.change_state("Hurt")		



func _on_RecoveryTimer_timeout():
	can_recover=true
	emit_signal("start_recovery")

func do_death():
	
	#$ExplodingGhost.initialize(load("res://assets/gfx/npcs/good_scare.png"))
	#sprite.visible=false
	#yield(get_tree().create_timer(1),"timeout")
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(sprite,"modulate", Color(1,1,1,0), 1)
	yield(tween, "finished")
	queue_free()
	
