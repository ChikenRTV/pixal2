extends StaticBody3D

@onready var anim = $Head/Pull/AnimatedSprite3D
@onready var ray = $Head/Pull/RayCast3D

var TARGET = null
var shooting = false



# Called when the node enters the scene tree for the first time.



func _on_target_body_entered(body):
	if body.is_in_group("enemy"):
		TARGET = body







func _on_target_body_exited(body):
	TARGET = null


func _on_timer_timeout():
	if TARGET:
		$Head.look_at(Vector3(TARGET.global_position.x,TARGET.global_position.y,TARGET.global_position.z), Vector3.UP)
		TARGET.takeDamage(1)
		$AudioStreamPlayer3D.play()
		anim.play("Shoot")
	else:
		anim.stop()
		anim.frame = 4
