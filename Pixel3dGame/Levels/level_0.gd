extends Node3D
var DiologText = ["Привет дорогой друг я куратор этой игры.Я тебя помогу как в это игратьюЧтобы двигаться нажимайте на стрелки",
"Чтобы прыгать, нажмите на кнопку SPACE",
"Кстати возьми оружие. Он в коробке",
'Чтобы стрелять, нажмите на Левую Кнопку Мыши.У вас не бесконечные патроны.Если закончились патроны, вам придётся ждать пока не зарядите',
'Нуладно, удачи!']

var hit_pro = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Diolog/Label.text = DiologText[0]
	$Player/Head/Camera3D/Pistol.visible = false


func Hit_progress():
	hit_pro += 1
	if hit_pro == 3:
		$Targets1.queue_free()


func _on_box_create_body_entered(body):
	if body.is_in_group("player"):
		$BoxCreate.queue_free()
		$Diolog/Label.text = DiologText[3]
		$Player/Head/Camera3D/Pistol.visible = true


func _on_diolog_232_body_entered(body):
	if body.is_in_group("player"):
		$Diolog232.queue_free()
		$Diolog/Label.text = DiologText[1]


func _on_diolog_233_body_entered(body):
	if body.is_in_group("player"):
		$Diolog233.queue_free()
		$Diolog/Label.text = DiologText[2]


func _on_diolog_234_body_entered(body):
	if body.is_in_group("player"):
		$Diolog234.queue_free()
		$Diolog/Label.text = DiologText[4]
