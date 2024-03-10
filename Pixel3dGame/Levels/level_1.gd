extends Node3D

var TimeSurivur = 30
var HpBashni = 160
var battar = 5
var startSave = false
var DiologText = ["Забыл сказать что, если ты хочешь поменять оружие,то нажимай на 1 или 2 то ты поменяешь оружие",
"Ворота закрыты. Чтобы открыть, нужно пойти к дону",
"Чтобы управлять дроном, нажимайте на стрелки, а чтобы летать на SPACE",
'Ворота Открыты!',
'Космический ТНТ долго будит подрываться,защищайте его чтобы люди не потушили']


var bullet = load("res://Enemy/enemy.tscn")
var TUR = load("res://Item/turier.tscn")
var TUR3 = load("res://Item/mine_b.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$tENTE.visible = false
	$Player.IsMove = false
	$Player.visible = false
	$StartSceene.set_current(true)
	$Diolog/Label.text = ""
	await get_tree().create_timer(2).timeout
	$MainSituation/AnimationPlayer.play("Fade1")
	await get_tree().create_timer(2).timeout
	$MainSituation/AnimationPlayer.play("Fade1_2")
	$Sirena.play()
	await get_tree().create_timer(2).timeout
	$MainSituation/AnimationPlayer.play("Fade1_3")
	await get_tree().create_timer(1).timeout
	get_tree().call_group('npc','hit')
	$Player/Jump2.play()
	await get_tree().create_timer(7).timeout
	$Sirena.stop()
	$Music.play()
	$Player/Control/Black/Move.play("Fade_In_2")
	await get_tree().create_timer(1).timeout
	$Player/Control/Black/Move.play("Fade_In")
	$Player/Head/Camera3D.set_current(true)
	$Player.IsMove = true
	$Player.visible = true
	$Diolog/Label.text = DiologText[0]
	$Diolog/Move.play("fade-in")
	await get_tree().create_timer(4).timeout
	$Diolog/Move.play("fade-out")


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
			$Player/Control/Black/Move.play("Fade_In_2")
			$Explose.play()
			get_tree().call_group('enemy','hit')
			$Floor5/Cave.visible = false
			$tENTE.visible = false
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
		$tENTE.visible = true
		$Tureli.visible = true
		$SaveZone/SaveHp/Timer.text = "Время:" + str(TimeSurivur)
		$SaveZone/SaveHp/ennergy.text = "Энергия:" + str(battar)
		$SaveZone/SaveHp.visible = true
		$SaveZone.monitoring = false
		$SaveZone.monitorable = false
		$ZaRabotu.play()
		$Diolog/Label.text = DiologText[4]
		$Diolog/Move.play("fade-in")
		await get_tree().create_timer(4).timeout
		$Diolog/Move.play("fade-out")
		


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
		$Diolog/Label.text = DiologText[2]
		$Diolog/Move.play("fade-in")
		$Helecopter.IsMove = true
		await get_tree().create_timer(4).timeout
		$Diolog/Move.play("fade-out")





func _on_diolog_sa_body_entered(body):
	if body.is_in_group('player'):
		$Diolog/Label.text = DiologText[1]
		$Diolog/Move.play("fade-in")
		$DiologSA.queue_free()
		await get_tree().create_timer(4).timeout
		$Diolog/Move.play("fade-out")


func _on_mine_b_2_body_entered(body):
	if body.is_in_group('heli'):
		$Worota/Open.play()
		$Player/Head/Camera3D.set_current(true)
		body.IsMove = true
		$Worota.visible = false
		$Worota/CollisionShape3D.queue_free()
		$Helecopter.IsMove = false
		if $DiologSA:
			$DiologSA.queue_free()
		$Diolog/Label.text = DiologText[3]
		$Player.IsMove = true
		$Diolog/Move.play("fade-in")
		await get_tree().create_timer(4).timeout
		$Diolog/Move.play("fade-out")
		
