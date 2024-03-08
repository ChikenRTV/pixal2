extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.EN_Bomb()


func _on_body_exited(body):
	if body.is_in_group("enemy"):
		body.EX_Bomb()


func _on_bomb_body_entered(body):
	if body.is_in_group("enemy"):
		$"Bomb!/CollisionShape3D".disabled = true
		visible = false
		$AudioStreamPlayer3D.play()
		body.Expouse_Bomb()
		await get_tree().create_timer(2).timeout
		queue_free()
		
