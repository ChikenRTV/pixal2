extends CharacterBody3D

@export var PlayerPath : NodePath
@export var color : Color
@export var aggroRange := 320
@export var fireSpeed := 0.2 
@export var attackPower := 1 
@export var Weapon := 2
var fire_on = false
var one = true
var Moveis = true
var Pase = 0

var HPZ = 10
var FreeMove = false
var material
var gravity = 9.8
var player = null 
var bombIs = false
var bullet = preload("res://Bullet/bullet.tscn") 

@onready var gun = $gun 
@onready var nav = $NavigationAgent3D
@onready var sight = $sight 
@onready var engagedTimer = $engaged

var lastShot := 0.0 
var speed := 5.0  

var startPos 
var engaged = false 

func _ready():
	$TimerPase.start()
	if Weapon == 0:
		$Head/Rig2/Shootgun.visible = false
		$Head/Rig2/LaserGun.visible = true
		$Head/Rig2/Sword.visible = false
		fireSpeed = 0.2
		attackPower = 1
		speed = 6.0 
	if Weapon == 1:
		$Head/Rig2/Shootgun.visible = true
		$Head/Rig2/LaserGun.visible = false
		$Head/Rig2/Sword.visible = false
		fireSpeed = 0.2
		attackPower = 5
		speed = 5.0 
	if Weapon == 2:
		$Head/Rig2/Shootgun.visible = false
		$Head/Rig2/LaserGun.visible = false
		$Head/Rig2/Sword.visible = true
		attackPower = 10
		speed = 8.0 
	player = $"../Player"
	startPos = global_position
	var mat = StandardMaterial3D.new()
	mat.set_albedo(color)
	mat.emission_enabled = true
	$%body.set_surface_override_material(0,mat)
	$%nose.set_surface_override_material(0,mat)
	material = mat
	
func takeDamage(dmg):
	get_tree().create_timer(0.2).timeout
	HPZ -= dmg
	engaged = true
	engagedTimer.start()
	if HPZ < 1:
		$"..".The_end()
		queue_free()
	var tween = get_tree().create_tween()
	tween.tween_property(material, "emission",Color(2,1,1,1), 0.02)
	tween.tween_property(material, "emission",Color(0,0,0,1), 0.2)

func _fire():
	var now := Time.get_ticks_msec()/1000.0
	if now < lastShot+fireSpeed: return
	
	lastShot = now
	var b = bullet.instantiate()
	b.global_transform = gun.global_transform
	get_parent().add_child(b)

func _process(delta):
	$Boss2/Bar.size.x = HPZ * 7.63
	if Pase == 0:
		boss_pase1(delta)
		
		
func boss_pase1(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	velocity = Vector3.ZERO
	if global_position.distance_to(player.global_position) < aggroRange or engaged: 
		nav.set_target_position(player.global_transform.origin)
		$AnimationPlayer.play("Walk")
		if one == true:
			one = false
			$Voice.play()
		if sight.is_colliding() and sight.get_collider().is_in_group("player"):
			fire_on = true
		else:
			fire_on = false
		$Head.look_at(Vector3(player.global_position.x, player.global_position.y,player.global_position.z))
	elif global_position.distance_to(startPos) > 5:
		nav.set_target_position(startPos)
		one = true
		$Head.look_at(Vector3(startPos.x, startPos.y,startPos.z),Vector3.UP)
	
	var nextPos = nav.get_next_path_position()
	
	velocity = (nextPos - global_transform.origin).normalized() * speed
	
	move_and_slide()

func EN_Bomb():
	bombIs = true
	
func EX_Bomb():
	bombIs = false
	
func Expouse_Bomb():
	if bombIs == true:
		queue_free()


func _on_shoot_timeout():
	if fire_on == true:
		$"../Player".takeDamage(attackPower)
		if Weapon == 0:
			$Head/Rig2/LaserGun/Shoot.play()
		elif Weapon == 1:
			$Head/Rig2/Shootgun/Shoot2.play()
		elif Weapon == 2:
			$Head/Rig2/Sword/Shoot3.play()


func _on_timer_pase_timeout():
	Pase = 1
	await get_tree().create_timer(4).timeout
	Pase = 0
	$TimerPase.start()
	

