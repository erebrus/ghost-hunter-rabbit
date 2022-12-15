extends Area2D

export(float) var speed:float = 600
export(float) var damage:float = 20
export(float) var ttl:float = 2

var velocity:Vector2 

onready var sprite:AnimatedSprite = $Sprite
var exploded:bool = false
func _ready():
	sprite.play("start")
	yield(sprite, "animation_finished")
	sprite.play("mid")
	$Timer.wait_time=ttl
	$Timer.start()
	

func _process(delta):
	if velocity.x<0:
		sprite.flip_h=true
		
	global_position += velocity*delta
	
func init(direction:Vector2)->void:
	velocity = direction.normalized()*speed
	


func _on_body_entered(body):
	velocity=Vector2.ZERO
	if body.has_method("take_damage"):
		body.take_damage(self, damage)
	sprite.play("collision")
	exploded=true
	yield(get_tree().create_timer(.1), "timeout")
	fade()
	yield(sprite, "animation_finished")
	do_destroy()
	
func fade():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "modulate",Color(1,1,1,0),.2)
	
func do_destroy():
	visible = false
	call_deferred("queue_free")
	
func _on_Timer_timeout():
	if not exploded:
		fade()

		do_destroy()
		
