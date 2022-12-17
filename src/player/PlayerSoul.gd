extends Sprite


onready var player = $AnimationPlayer
onready var notifier = $VisibilityNotifier2D
export(float) var max_speed=300

var accel=1
var speed=0
var max_scale:Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.play("default")
	modulate.a=0
	max_scale=scale
	scale = Vector2(.1,.1)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", max_scale,.4)
	tween.parallel().tween_property(self, "modulate", Color(1,1,1,1),.3)

func _process(delta: float) -> void:
	
#	if modulate.a < 1:
#		modulate.a +=.025
#		return
	
	accel = 1*2
	speed = clamp (speed + accel, 0 , max_speed)
	global_position.y -= speed*delta
	if not notifier.is_on_screen():
		Globals.emit_signal("game_over")
	
