extends CharacterBody3D


const SPEED = 14.0
const JUMP_VELOCITY = 8.5
const SENSITIVITY = 0.03
var PATRONS = 10
var ENEMYCON = 10
var PLAYERHP = 100
var HIT_S = false
var SELECT_WEAPON = 2
var IsMove = true
var Group_Glav = ["Обучение",
"Хьюстан,у нас проблемы!",
"Обманчевый лаберинт",
"Последняя Спасение"]

var FIRST_FACE = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8
var falling = false

@onready var hub = $".."
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var pistolAnim = $Head/Camera3D/Pistol/AnimationPlayer
@onready var pistol = $Head/Camera3D/Pistol/AudioStreamPlayer
@onready var pistol_ray = $Head/Camera3D/Pistol/RayCast3D
@onready var pistol2Anim = $Head/Camera3D/LaserSword/AnimationPlayer
@onready var pistol2 = $Head/Camera3D/LaserSword/AudioStreamPlayer
@onready var pistol2_ray = $Head/Camera3D/LaserSword/RayCast3D

var bullet = load("res://Bullet/sword_attacker.tscn")



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Patrons/Label.text = str(PATRONS)
	$Control/Black/Move.play("Fade_In")
	
	$EnemyIcon/Label.text = str(ENEMYCON)
	$Glavu/Label.text = Group_Glav[Global.Level_Number]
	$Control/ColorRect.scale.x = PLAYERHP / 10
	weapon_select(1)
	if Global.Rig_Det == false:
		$Head/Camera3D/Pistol.position.x = -0.317
		$Head/Camera3D/LaserSword.position.x = -0.317
		$Head/LegOther.position.x = 0.317
	elif Global.Rig_Det == true:
		$Head/Camera3D/Pistol.position.x = 0.317
		$Head/Camera3D/LaserSword.position.x = 0.317
		$Head/LegOther.position.x = -0.317
	$Glavu/Move.play("in")
	await get_tree().create_timer(2).timeout
	$Glavu/Move.play("out")
	
func _input(event):
	if PLAYERHP > 0 and FIRST_FACE == true:
		if event is InputEventMouseMotion:
			
			head.rotate_y(-event.relative.x * SENSITIVITY)
			camera.rotate_x(-event.relative.y * SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40),deg_to_rad(60))

func _physics_process(delta):
	# Add the gravity.
	if PLAYERHP > 0 and IsMove == true:
		Player_input(delta)
	if IsMove == true:
		$Prihel.visible = true
	elif IsMove == false:
		$Prihel.visible = false
	if FIRST_FACE == false:
		$Head/Camera3D.visible = false
		$Head/Pistol.visible = true
		$"Head/3hed".visible = true
	elif FIRST_FACE == true:
		$Head/Camera3D.visible = true
		$Head/Pistol.visible = false
		$"Head/3hed".visible = false

func Player_input(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if not is_on_floor() and falling == false:
		await get_tree().create_timer(0.1).timeout
		if not is_on_floor():
			falling = true

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and FIRST_FACE == true:
		velocity.y = JUMP_VELOCITY
		
	if is_on_floor() and falling == true:
		falling = false
		$Jump.play()


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor() and FIRST_FACE == true:
		if direction:
			if Input.is_action_pressed("Sprint"):
				velocity.x = direction.x * SPEED * 2
				velocity.z = direction.z * SPEED * 2
				print("Ускорился")
			else:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
		else:
			velocity.x = 0
			velocity.z = 0
	else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 2)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 2)
		
	if Input.is_action_pressed("shoot"):
		if SELECT_WEAPON == 1:
			if !pistolAnim.is_playing() and PATRONS >0 :
				pistol.play()
				PATRONS -= 1
				$Patrons/Label.text = str(PATRONS)
				pistolAnim.play("Shoot")
				var instance = bullet.instantiate()
				instance.global_position = pistol_ray.global_position
				instance.global_transform = pistol_ray.global_transform
				get_parent().add_child(instance)
		elif SELECT_WEAPON == 2:
			if !pistol2Anim.is_playing():
				pistol2.play()
				$Head/Camera3D/LaserSword/ColisonEnemy.monitoring = false
				$Head/Camera3D/LaserSword.canKill = true
				pistol2Anim.play("Shoot")
				await get_tree().create_timer(0.5).timeout
				$Head/Camera3D/LaserSword/ColisonEnemy.monitoring = true
				$Head/Camera3D/LaserSword.canKill = false
		if !pistolAnim.is_playing() and PATRONS <=0 :
			$Patrons/Label.text = "Перезарядка"
			pistolAnim.play("magReload")
			await get_tree().create_timer(1).timeout
			PATRONS = 10
			$Patrons/Label.text = str(PATRONS)
	if Input.is_action_just_pressed("1"):
		weapon_select(1)
	if Input.is_action_just_pressed("2"):
		weapon_select(2)

	move_and_slide()

func buy_t(sa):
	$Control/OpenE.visible = true
	if Input.is_action_just_pressed("E") and hub.battar >= 4:
		sa.visible = false
		$Control/OpenE.visible = false
		sa.get_node("CollisionShape3D").disabled = true
		$"..".buy_t(sa.global_position)
	if Input.is_action_just_pressed("R") and hub.battar >= 2:
		sa.visible = false
		$Control/OpenE.visible = false
		sa.get_node("CollisionShape3D").disabled = true
		$"..".buy_t2(sa.global_position)
	
func close_t():
	$Control/OpenE.visible = false

func takeDamage(dmg):
		PLAYERHP -= dmg
		$DamageRed.visible = true
		$Control/ColorRect.scale.x = PLAYERHP / 10
		if PLAYERHP <= 0: 
			$GameOver.visible = true
			Input.set_mouse_mode(0)
		await get_tree().create_timer(0.1).timeout
		$DamageRed.visible = false
func _on_colison_item_body_entered(body):
	
	if body.is_in_group("Chest"):
		$Control/OpenE.visible = true
		var anima = body.get_node('AnimationPlayer')
		var anima2 = body.get_node('CollisionShape3D')
		while $Control/OpenE.visible == true:
			await get_tree().create_timer(0.1).timeout
			if Input.is_action_pressed("E"):
				print("privet")
				$Control/OpenE.visible = false
				anima2.queue_free()
				anima.play("CrateOpen")
				body.Open = true
				PATRONS += 5
				
				$Patrons/Label.text = str(PATRONS)




func _on_colison_item_body_exited(body):
	if body.is_in_group("Chest"):
		$Control/OpenE.visible = false


func dead_enemy():
	ENEMYCON -= 1
	$EnemyIcon/Label.text = str(ENEMYCON)


func The_End():
	$Control/Black/Move.play("Fade_In")
	IsMove = false
	await get_tree().create_timer(4).timeout
	Input.set_mouse_mode(0)
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_game_over_button_pressed():
	get_tree().reload_current_scene()

func get_batarey():
	if  $"..":
		$"..".get_batarey()

func weapon_select(w):
	SELECT_WEAPON = w
	if SELECT_WEAPON == 1:
		$Head/Camera3D/LaserSword.visible = false
		$Head/Camera3D/Pistol.visible = true
	
	elif SELECT_WEAPON == 2:
		$Head/Camera3D/LaserSword.visible = true
		$Head/Camera3D/Pistol.visible = false
		
func get_hp(h):
	PLAYERHP += h
	if PLAYERHP > 100:
		PLAYERHP = 100
