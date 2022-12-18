extends Area2D
class_name Orb

signal burst(orb)

enum State {ORBITING, GOING, RETURNING, ATTRACTED, ABSORTION}

var checkpoint
var offset

onready var sprite:Sprite = $Sprite
onready var light:Light2D = $Light2D
onready var player:AnimationPlayer = $Sprite/AnimationPlayer
onready var sfx_burst:AudioStreamPlayer2D = $sfx_burst
onready var explosion = $ExplodingOrb
onready var xsm = $XSM

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
