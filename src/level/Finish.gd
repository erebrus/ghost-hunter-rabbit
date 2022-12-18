extends Area2D
signal level_complete()

var done := false

func _on_body_entered(body):
	if not done and body == Globals.get_player():
		body.velocity=Vector2.ZERO
		body.update_sprite()
		body.dead = true
		body.in_animation = true
		emit_signal("level_complete")
		Logger.info("Level complete")
		done = true

		
		
