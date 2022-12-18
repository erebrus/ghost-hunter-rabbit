extends Area2D

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
	if body.has_method("consume_as_fuel"):
		add_energy(body.consume_as_fuel(absortion_point.global_position))		
		
func add_energy(delta:float):
	yield(get_tree().create_timer(.3), "timeout")
	energy = clamp (energy + delta, 0, max_energy)
	update_level()	
	if energy == max_energy:
		Globals.emit_signal("level_complete")
