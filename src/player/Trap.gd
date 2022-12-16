extends Area2D

export(float) var capture_distance:float=100
export(float) var force:float=100

var ghosts:=[]

func _on_Trap_area_entered(area):
	var body = area.get_parent()
	if body.is_in_group("ghost"):
		ghosts.append(body)


func _on_Trap_area_exited(area):
	ghosts.erase(area.get_parent())


func _process(delta):
	var to_remove=[]
	for g in ghosts:
		if g.xsm.is_active("Hurt"):
			var dpos = $Position2D.global_position-g.global_position
			if dpos.length()<16:
				g.xsm.change_state("Death")
				g.desired_velocity = Vector2.ZERO
				to_remove.append(g)
			else:
				g.desired_velocity = dpos.normalized()*force
				
	for g in to_remove:
		ghosts.erase(g)
	
		
