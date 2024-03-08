extends CharacterBody3D

@export var PlayerPath : NodePath
@export var color : Color
@export var aggroRange := 20
@export var fireSpeed := 0.2 
@export var attackPower := 1 

var HPZ = 3
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
	velocity = Vector3.ZERO
	if not is_on_floor():
		velocity.y -= gravity * delta
	if global_position.distance_to(player.global_position) < aggroRange or engaged: 
		nav.set_target_position(player.global_transform.origin)
		if sight.is_colliding() and sight.get_collider().is_in_group("player"):
			_fire()
		look_at(Vector3(player.global_position.x, player.global_position.y,player.global_position.z),Vector3.UP)
	elif global_position.distance_to(startPos) > 5:
		nav.set_target_position(startPos)
		look_at(Vector3(startPos.x, startPos.y,startPos.z),Vector3.UP)
	
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
