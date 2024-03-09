extends Node3D
var DiologText = ["Чтобы пойти, нужно идти в лабиринт и там открыть рычаг",
"Отлично теперь пойдё обратно",
"Упс, походу нас закрыли. Давай попробуем найти в лабиринте что-то",
'Мы открыли рычак, скорее всего то выход!']


# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.play()
	$Wall5.visible = false
	$Wall5/CollisionShape3D.disabled = false


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
		$Wall5/CollisionShape3D.disabled = true
		await get_tree().create_timer(5).timeout
		$Diolog/Move.play("fade-out")


func _on_diolog_se_2_body_entered(body):
	if body.is_in_group("player") and $Wall5.visible == true:
		$Diolog/Label.text = DiologText[2]
		$Diolog/Move.play("fade-in")
		$DiologSe.queue_free()
		await get_tree().create_timer(5).timeout
		$Diolog/Move.play("fade-out")


func _on_rachek_2_body_entered(body):
	if body.is_in_group("player") and $Rachek2.visible == true:
		$Diolog/Label.text = DiologText[3]
		$Diolog/Move.play("fade-in")
		$Rachek2/CollisionShape3D.queue_free()
		$Rachek2/AnimationPlayer.play("Open")
		await get_tree().create_timer(5).timeout
		$Diolog/Move.play("fade-out")
