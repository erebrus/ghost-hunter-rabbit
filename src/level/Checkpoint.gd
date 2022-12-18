extends Area2D
signal checkpoint_full()


export(float) var max_energy:float = 300
export(float) var energy:float=0

export(bool) var enabled:bool = true
onready var deposit:Sprite  = $DepositSprite
onready var absortion_point:Position2D = $AbsortionPoint
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_level()
	

func update_level():
	if not enabled:
		return
	var pct:float = energy/max_energy	
	deposit.material.set_shader_param("pct",pct)

func _on_Checkpoint_body_entered(body: Node) -> void:
	if body.has_method("on_checkpoint"):
		body.on_checkpoint(self)	
		
func add_energy(delta:float):
	
	var tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	energy = clamp (energy + delta, 0, max_energy)
	tween.tween_property(deposit.material, "shader_param/pct",  energy/max_energy, .3)
	if energy == max_energy:
		emit_signal("checkpoint_full")

func get_capture_position():
	return $AbsortionPoint.global_position
