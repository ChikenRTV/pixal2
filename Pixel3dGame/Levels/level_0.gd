extends Node3D

var hit_pro = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/Head/Camera3D/Pistol.visible = false


func Hit_progress():
	hit_pro += 1
	if hit_pro == 3:
		$Targets1.queue_free()


func _on_box_create_body_entered(body):
	if body.is_in_group("player"):
		$BoxCreate.queue_free()
		$Player/Head/Camera3D/Pistol.visible = true
