extends Area2D

export(Vector2) var tilemap_offset
export(bool) var do_ouch:= false

func _on_Spikes_body_entered(body):
	if body == Globals.get_player():
		body.do_element_death(do_ouch)
		

func get_tilemap_offset():
	return tilemap_offset
	
