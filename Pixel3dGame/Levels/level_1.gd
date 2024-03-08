extends Node3D

var TimeSurivur = 160
var HpBashni = 160
var battar = 5


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
			
			$Player/Control/White/Move.play("Fade_In_2")
			get_tree().call_group('enemy','hit')
			await get_tree().create_timer(3).timeout
			get_tree().change_scene_to_file("res://main_menu.tscn")
			

func get_batarey():
	battar += 4
	$SaveZone/SaveHp/ennergy.text = "Энергия:" + str(battar)
	

func _on_save_zone_body_entered(body):
	if body.is_in_group("player"):
		$Music.stop()
		$Sirena2.play()
		$Tureli.visible = true
		$SaveZone/SaveHp/Timer.text = "Время:" + str(TimeSurivur)
		$SaveZone/SaveHp/ennergy.text = "Энергия:" + str(battar)
		$SaveZone/SaveHp.visible = true
		$SaveZone/CollisionShape3D.disabled = true
		


func _on_spawn_enemy_timeout():
	if $SaveZone/SaveHp.visible == true:
		$Decoration/Blcok.position.y = 4.302
		$Decoration/Blcok.position.z = 100.491
		$Decoration/Blcok.position.x = randf_range(-7.845,10.518)
		var instance = bullet.instantiate()
		instance.aggroRange = 10000
		instance.speed = 25
		instance.position = $Decoration/Blcok.global_position
		add_child(instance)
		

