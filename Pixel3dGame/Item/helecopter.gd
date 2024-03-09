extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 16.5
var IsMove = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func Input_helicopter(delta):
	# Add the gravity.
	$gyro.rotate_y(deg_to_rad(-4))
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _physics_process(delta):
	if IsMove == true:
		Input_helicopter(delta)

func takeDamage(dmg):
	$"../Player".takeDamage(dmg)

func _on_colision_body_entered(body):
	if body.is_in_group("lazer"):
		takeDamage(23)
