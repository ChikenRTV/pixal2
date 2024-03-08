extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
var SPEED = 9.8
var HPZ = 3
var RANGE = 3
var HIT_CAN = false
const gravity = 9.8
var bombIs = false

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var current_location = global_transform.origin
	
	var next_location = nav_agent.get_next_path_position()
	
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = velocity.move_toward(new_velocity, .25)
	move_and_slide()
	

	
func target_location(target_location):
	
	nav_agent.target_position = target_location

func hit():
	if HPZ > 0:
		HPZ -= 3
		print(HPZ)
		if HPZ <= 0:
		
			$"../Player".dead_enemy()
			$GPUParticles3D.emitting = true
			await get_tree().create_timer(0.1).timeout
			$MeshInstance3D.visible = false
			await get_tree().create_timer(0.9).timeout
		
			queue_free()

func hit2():
	if HPZ > 0:
		HPZ -= 1
		print(HPZ)
		if HPZ <= 0:
		
			$"../Player".dead_enemy()
			$GPUParticles3D.emitting = true
			await get_tree().create_timer(0.1).timeout
			$MeshInstance3D.visible = false
			await get_tree().create_timer(0.9).timeout
		
			queue_free()


func _on_area_3d_2_body_entered(body):
	if body.is_in_group('player'):
		HIT_CAN = true
		print("попал")





func _on_area_3d_2_body_exited(body):
	if body.is_in_group('player'):
		HIT_CAN = false
		print("не попал")


func _on_cooldown_timeout():
	if HIT_CAN == true and $"../Player".PLAYERHP >0 and HPZ > 0:
		$"../Player".hit_me()


func _on_timer_timeout():
	if $"../Player".PLAYERHP >0 or HPZ > 0:
		var player = $"../Player"
		look_at(Vector3(player.global_position.x,0,player.global_position.z), Vector3.UP)
		if HIT_CAN == false:
			target_location(player.global_position)

func EN_Bomb():
	bombIs = true
	
func EX_Bomb():
	bombIs = false
	
func Expouse_Bomb():
	if bombIs == true:
			$"../Player".dead_enemy()
			$GPUParticles3D.emitting = true
			await get_tree().create_timer(0.1).timeout
			$MeshInstance3D.visible = false
			await get_tree().create_timer(0.9).timeout
		
			queue_free()
