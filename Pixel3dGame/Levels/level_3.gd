extends Node3D
var DiologText = ["Чтобы пойти, нужно идти в лабиринт и там открыть рычаг",
"Отлично теперь пойдём обратно",
"Упс, походу нас закрыли. Давай попробуем найти в лабиринте что-то",
'Мы открыли рычак, скорее всего это выход!']

var boss = 100

@onready var d = load("res://Enemy/Boss.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Diolog/Label.text = ""

func _physics_process(delta):
	if $Player.position.y <= -13.007:
		get_tree().reload_current_scene()
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_diolog_2_body_entered(body):
	if body.is_in_group("player"):
		body.IsMove = false
		$Diolog/Move.play("fade-in")
		$Diolog2/CollisionShape3D.queue_free()
		$Diolog/Label.text = "Хах, ты думал что, это тачка бесплатное?"
		await get_tree().create_timer(3).timeout
		$Diolog/Label.text = "Самом деле я робот, я вас предал"
		await get_tree().create_timer(3).timeout
		$Diolog/Label.text = "Теперь умирай!!!"
		$Music.play()
		var i = d.instantiate()
		i.position = Vector3(2.75,4.573,38.695)
		add_child(i)
		body.IsMove = true

func The_end():
	await get_tree().create_timer(1).timeout
	$Player.IsMove = false
	$Player/Control/Black/Move.play("Fade_In_2")
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Levels/title.tscn")
	Input.set_mouse_mode(0)
