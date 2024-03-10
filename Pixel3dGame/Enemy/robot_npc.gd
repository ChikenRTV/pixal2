extends CharacterBody3D
@export var Running = false
var SPEED = 0.6
# Called when the node enters the scene tree for the first time.

func hit():
	Running = true


func _process(delta):
	if Running == true:
		$AnimationPlayer.play("Stand")
		position += Vector3(-SPEED, 0, 0)

