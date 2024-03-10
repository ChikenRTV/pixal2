extends Area3D

@onready var node = $"."

func _physics_process(delta):
	rotate_y(deg_to_rad(-1))

func _on_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
		body.get_hp(25)
