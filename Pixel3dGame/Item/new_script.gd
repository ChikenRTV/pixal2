extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
var SPEED = 3.8
var HPZ = 10
var RANGE = 3
var HIT_CAN = false
const gravity = 9.8
func _physics_process(delta):
	
	velocity.y -= 1 * delta
	

