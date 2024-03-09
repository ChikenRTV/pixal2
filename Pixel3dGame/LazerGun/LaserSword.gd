extends Node3D

var canKill = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_colison_enemy_body_entered(body):
	if body.is_in_group("enemy"):
		print("popooppooppopopo")
	if body.is_in_group("enemy"):
		body.takeDamage(1.5)
