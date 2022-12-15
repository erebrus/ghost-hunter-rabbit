extends KinematicBody2D


signal player_detected

export(bool) var spectral_world:bool = false
export(bool) var material_world:bool = true
export(int) var max_hp:int = 30
export(float) var normal_speed:float = 50
export(float) var engage_speed:float = 100

export(float) var attack_damage:float = 25
export(float) var attack_reload:float = 1

export(NodePath) var patrol_path


var can_attack:bool = true
var velocity:=Vector2()
var direction:int=0
var target
onready var hp:int =max_hp

onready var floor_rc:RayCast2D = $FloorRaycast
onready var front_rc:RayCast2D = $FrontRaycast
onready var sprite:AnimatedSprite = $Sprite
onready var detection_box = $DetectionBox/CollisionShape2D
onready var attack_box = $Attack1HitBox/CollisionShape2D
onready var reload_timer = $ReloadTimer
onready var xsm = $XSM

var dist_to_enemy:float=0


func _ready() -> void:
	Globals.get_world().connect("world_state_changed", self, "_on_world_state_changed")
#	setup_debug(true)


func set_exists(val:bool)->void:
	visible = val
	floor_rc.enabled = val
	front_rc.enabled = val
	detection_box.disabled = !val
	attack_box.disabled = !val
	$CollisionShape2D.disabled = !val
	if not val:
		xsm.change_state("OffPlane")
	
func exists_in_current_world_state():
	if Globals.get_world().state==Globals.WorldState.MATERIAL:
		return material_world
	else:
		return spectral_world


func _on_world_state_changed():
	set_exists(exists_in_current_world_state())

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
		attack_box.position.x=-attack_box.position.x


func _process(delta: float) -> void:
	if not exists_in_current_world_state():
		return
	if is_on_floor():
		velocity.y=0
	else:
		velocity.y += 1000 * delta
	check_direction()
	
	velocity=move_and_slide(velocity, Vector2.UP)
	dist_to_enemy=-1 if not target else global_position.distance_to(target.global_position)

func _on_ReloadTimer_timeout() -> void:
	can_attack = true
	attack_box.disabled=false

func _on_DetectionBox_body_entered(body: Node) -> void:
	if body == Globals.get_player():
		target = body


func _on_DetectionBox_body_exited(body: Node) -> void:
	if body == Globals.get_player():
		target = null

func do_attack():
	can_attack=false
	
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

