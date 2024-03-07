extends CharacterBody3D
@export var Running = true
var SPEED = 0.6
# Called when the node enters the scene tree for the first time.




func _process(delta):
	if Running == true:
		$AnimationPlayer.play("Stand")
		position += Vector3(0, 0, SPEED)

