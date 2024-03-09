extends Node3D

var TimeSurivur = 30
var HpBashni = 160
var battar = 5
var startSave = false


var bullet = load("res://Enemy/enemy.tscn")
var TUR = load("res://Item/turier.tscn")
var TUR3 = load("res://Item/mine_b.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(2).timeout
	$MainSituation/AnimationPlayer.play("Fade1")
	await get_tree().create_timer(2).timeout
	$MainSituation/AnimationPlayer.play("Fade1_2")
	$Sirena.play()
	await get_tree().create_timer(2).timeout
	$MainSituation/AnimationPlayer.play("Fade1_3")
	await get_tree().create_timer(1).timeout
	$Player/Jump2.play()
	await get_tree().create_timer(7).timeout
	$Sirena.stop()
	$Music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func buy_t(xd):
	battar -= 4
	$SaveZone/SaveHp/ennergy.text = "Энергия:" + str(battar)
	var TUR2 = TUR.instantiate()
	TUR2.position = xd
	add_child(TUR2)
	
func buy_t2(xd):
	battar -= 2
	$SaveZone/SaveHp/ennergy.text = "Энергия:" + str(battar)
	var TUR4 = TUR.instantiate()
	TUR4.position = xd
	add_child(TUR4)

func _on_timer_sec_timeout():
	if $SaveZone/SaveHp.visible == true and TimeSurivur > 0:
		TimeSurivur -= 1
		$SaveZone/SaveHp/Timer.text = "Время:" + str(TimeSurivur)
		if TimeSurivur <= 0:
			$SpawnEnemy.queue_free()
			$Control/Black.play("Fade_In_2")
			$Explose.play()
			get_tree().call_group('enemy','hit')
			$Floor5/Cave.visible = false
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_file("res://main_menu.tscn")
			Input.set_mouse_mode(0)
			

func get_batarey():
	battar += 4
	$SaveZone/SaveHp/ennergy.text = "Энергия:" + str(battar)
	

func _on_save_zone_body_entered(body):
	if body.is_in_group("player") and startSave == false:
		$Worota.queue_free()
		$Music.stop()
		startSave = true
		$Sirena2.play()
		$Tureli.visible = true
		$SaveZone/SaveHp/Timer.text = "Время:" + str(TimeSurivur)
		$SaveZone/SaveHp/ennergy.text = "Энергия:" + str(battar)
		$SaveZone/SaveHp.visible = true
		$SaveZone.monitoring = false
		$SaveZone.monitorable = false
		


func _on_spawn_enemy_timeout():
	if $SaveZone/SaveHp.visible == true:
		$Decoration/Blcok.position.y = 4.302
		$Decoration/Blcok.position.z = 100.491
		$Decoration/Blcok.position.x = randf_range(-7.845,10.518)
		var instance = bullet.instantiate()
		instance.aggroRange = 10000
		instance.speed = 15
		instance.position = $Decoration/Blcok.global_position
		add_child(instance)
		



func _on_fly_ver_body_entered(body):
	if body.is_in_group('player'):
		$Helecopter/Camera3D.set_current(true)
		body.IsMove = false
		$Helecopter.IsMove = true


func _on_rachek_body_entered(body):
	if body.is_in_group('heli'):
		$Player/Head/Camera3D.set_current(true)
		body.IsMove = true
		$Worota.visible = false
		$Worota/CollisionShape3D.disabled = false
		$Helecopter.IsMove = false
