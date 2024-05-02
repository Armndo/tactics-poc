extends CharacterBody3D
class_name Character

const SPEED = 2.5
const JUMP_VELOCITY = 3.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if position[1] < -5:
		position = Vector3(0, 1, 0)

	# Handle jump.
	if Input.is_action_pressed("a-button") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("d-left", "d-right", "d-up", "d-down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
