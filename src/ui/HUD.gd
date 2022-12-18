extends Control

const FULL_HEART=preload("res://assets/ui/050-small.png")
const EMPTY_HEART=preload("res://assets/ui/052-small.png")

	

func update_health():
	var health = Globals.get_player().hp
	var max_health = Globals.get_player().max_hp
	var container = $MarginContainer/HeathContainer
	var hp_count=int(health/max_health*5)
	for i in range(0,hp_count):
		var heart = container.get_child(i)
		if heart.texture != FULL_HEART:
			heart.texture = FULL_HEART
	if hp_count < 5:
		for i in range(hp_count,5):
			var heart = container.get_child(i)
			if heart.texture != EMPTY_HEART:
				heart.texture = EMPTY_HEART
			
	
	
	



func _on_Player_hp_updated():
	update_health()
