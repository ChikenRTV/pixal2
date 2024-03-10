extends Node3D
var DiologText = ["Чтобы пойти, нужно идти в лабиринт и там открыть рычаг",
"Отлично теперь пойдём обратно",
"Упс, походу нас закрыли. Давай попробуем найти в лабиринте что-то",
'Мы открыли рычак, скорее всего это выход!']


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.IsMove = false
	$MainCamera.set_current(true)
	$Diolog/Label.text = ""
	$Music.play()
	$Wall5.visible = false
	$Rachek2.visible = false
	$Liuk.visible = false
	$Wall5.set_collision_layer_value ( 1, false )
	print($Wall5.position)
	$Wall5/CollisionShape3D.disabled = false
	await get_tree().create_timer(2).timeout
	$Player/Control/Black/Move.play("Fade_In_2")
	
	await get_tree().create_timer(1).timeout
	$Player/Control/Black/Move.play("Fade_In")
	$Player/Head/Camera3D.set_current(true)
	$Player.IsMove = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_diolog_se_body_entered(body):
	if body.is_in_group("player"):
		$Diolog/Label.text = DiologText[0]
		$Diolog/Move.play("fade-in")
		$DiologSe.queue_free()
		await get_tree().create_timer(2).timeout
		$Diolog/Move.play("fade-out")


func _on_rachek_body_entered(body):
	if body.is_in_group("player"):
		$Diolog/Label.text = DiologText[1]
		$Diolog/Move.play("fade-in")
		$Rachek/CollisionShape3D.queue_free()
		$Rachek/AnimationPlayer.play("Open")
		$Wall5.visible = true
		$Wall5.set_collision_layer_value ( 1, true )
		print($Wall5.position)
		await get_tree().create_timer(5).timeout
		$Diolog/Move.play("fade-out")


func _on_diolog_se_2_body_entered(body):
	if body.is_in_group("player") and $Wall5.visible == true:
		$Diolog/Label.text = DiologText[2]
		$Diolog/Move.play("fade-in")
		$DiologSe2.queue_free()
		$Rachek2.visible = true
		await get_tree().create_timer(5).timeout
		$Diolog/Move.play("fade-out")


func _on_rachek_2_body_entered(body):
	if body.is_in_group("player") and $Rachek2.visible == true:
		$Diolog/Label.text = DiologText[3]
		$Diolog/Move.play("fade-in")
		$Rachek2/CollisionShape3D.queue_free()
		$Rachek2/AnimationPlayer.play("Open")
		$Liuk.visible = true
		await get_tree().create_timer(5).timeout
		$Diolog/Move.play("fade-out")


func _on_liuk_body_entered(body):
	if body.is_in_group("player") and $Liuk.visible == true:
		$Player.IsMove = false
		$Player/Control/Black/Move.play("Fade_In_2")
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://main_menu.tscn")
		Input.set_mouse_mode(0)
