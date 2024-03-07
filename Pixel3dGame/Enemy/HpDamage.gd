extends StaticBody3D
var HPZ = 3
var RANGE = 3
var HIT_CAN = false
@onready var targetin = $"../.."

func hit():
	if HPZ > 0:
		HPZ -= 3
		print(HPZ)
		if HPZ <= 0:
		
			$"../../Player".dead_enemy()
			$GPUParticles3D.emitting = true
			await get_tree().create_timer(0.1).timeout
			visible = false
			targetin.Hit_progress()
			$AudioStreamPlayer3D.playing = true
			await get_tree().create_timer(0.9).timeout
		
			queue_free()



