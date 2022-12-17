extends Node2D



func _on_Timer_timeout():
	print ("starting")
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($GoodScare.material,"shader_param/deformation", Vector2(.4,0), .4)
	tween.parallel().tween_property($GoodScare.material,"shader_param/bulge", -1.1, .4)
	tween.parallel().tween_property($GoodScare, "scale", Vector2(1,.4),.7).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property($GoodScare, "offset", Vector2(0,312),.7).set_ease(Tween.EASE_IN)		
#	tween.parallel().tween_property($GoodScare, "modulate", Color(1,1,1,0),.6).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)		
	yield(tween,"finished")
	
	#($GoodScare.material as ShaderMaterial).set_shader_param("bulge", -1)
	print ("done")
