extends Area3D

var OpenIs = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite3D.play("default")
	if OpenIs == true and $"../../SaveZone/SaveHp".visible == true:
		$"../../Player".buy_t(self)


func _on_body_entered(body):
	if body.is_in_group("player"):
		OpenIs = true
		
		


func _on_body_exited(body):
	if body.is_in_group("player"):
		OpenIs = false
		body.close_t()
