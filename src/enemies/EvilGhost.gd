extends "res://src/enemies/Enemy.gd"

onready var sfx_scream = $sfxScream

var screaming:=false
func do_attack():
	sfx_scream.play()
	screaming = true
	yield(get_tree().create_timer(2), "timeout")
	screaming = false

	sfx_scream.stop()
	
	
func _process(delta):
	._process(delta)
	
	var attack_box = $ScreamBox/CollisionShape2D
	attack_box.position.x=-256 if sprite.flip_h else 0
	attack_box.disabled=not screaming
	
func _on_ScreamBox_body_entered(body: Node) -> void:
	if body == Globals.get_player():
		target = body
		body.take_damage(self, attack_damage, false)
		screaming=false
	
