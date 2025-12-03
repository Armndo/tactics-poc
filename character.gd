extends CharacterBody3D
class_name Character

@onready var sprite = $CharacterSprite
@onready var spriteShadow = $CharacterShadow

const SPEED = 2.5
const JUMP_VELOCITY = 3.0
const CURSOR_FRAME_RATE = 6
const MOVE_SPEED = 15
const DEFAULT_SPRITE_YPOS = -0.0625
const DEFAULT_SPRITE_YROT = PI/4
const ROTATION_SPEED = 10
var speed_buff = 1
var frame_count = 0
var init = false
var xpos = 0
var zpos = 0
var yrot = DEFAULT_SPRITE_YROT


var camera : CameraControl = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func configure(my_camera : CameraControl):
	camera = my_camera
	#position = Vector3(0, 1, 0)

func _ready():
	sprite.play("idle_walk")
	spriteShadow.play("idle_walk")
	pass
	#position = Vector3(0, 1, 0)

func _physics_process(delta):
	#print(spriteShadow.position)
	if camera.orientation < 0:
		#print("a")
		zpos = -.25
		yrot = 0
		#spriteShadow.rotation.y = PI/8
		#spriteShadow.rotation_degrees.y = 0
	elif camera.orientation > 0:
		#print("b")
		xpos = -.25
		yrot = PI/2
		#spriteShadow.rotation.y = -PI/8
		#spriteShadow.position = Vector3(0, DEFAULT_SPRITE_YPOS, -.125)
		#sprite.alpha_cut = 0
		#spriteShadow.show()
	else:
		xpos = 0
		zpos = 0
		yrot = DEFAULT_SPRITE_YROT
		#spriteShadow.rotation.y = PI/2
		#spriteShadow.position = Vector3(0, DEFAULT_SPRITE_YPOS, 0)
		#spriteShadow.rotation_degrees = Vector3(0, 90, 0)
		#spriteShadow.rotate(Vector3(0, 90, 0), 0)
		#spriteShadow.rotation_degrees.y = 90
		#sprite.alpha_cut = 2
		#spriteShadow.hide()
		
	#print(spriteShadow.rotation.y, " - ", yrot)
	#print(spriteShadow.rotation)
	#print(camera.camera.rotation)

	#if spriteShadow.rotation.y != yrot:
		#spriteShadow.rotation.y = lerp_angle(spriteShadow.rotation.y, yrot, ROTATION_SPEED*delta)

	var target_position = Vector3(xpos, DEFAULT_SPRITE_YPOS, zpos)

	if sprite.position != target_position:
		sprite.position = lerp(sprite.position, target_position, .25)

	if not init:
		init = true
		#position = Vector3(0, .125, 0)
	
	frame_count += 1
	#print(camera.pos)
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta

	if position[1] < -5:
		position[1] = 5
		velocity.y = 0

	if Input.is_action_just_pressed("select"):
		position = Vector3(.125, 0.176, .125)
		velocity.y = 0
		velocity.x = 0
		velocity.z = 0		

	#if Input.is_action_pressed("b-button"):
		#speed_buff = 1.5
	#else:
		#speed_buff = 1

	## Handle jump.
	#if Input.is_action_pressed("a-button") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	var held_down = frame_count % CURSOR_FRAME_RATE == 0
	var move_flag = Input.get_vector("l-stick-l", "l-stick-r", "l-stick-u", "l-stick-d") != Vector2(0, 0)
	
	if held_down and move_flag:
		if camera.orientation > 0:
			if Input.is_action_pressed("l-stick-l"):
				velocity.z = MOVE_SPEED
			elif Input.is_action_pressed("l-stick-r"):
				velocity.z = -MOVE_SPEED
			elif Input.is_action_pressed("l-stick-u"):
				velocity.x = -MOVE_SPEED
			elif Input.is_action_pressed("l-stick-d"):
				velocity.x = MOVE_SPEED
		else:
			if Input.is_action_pressed("l-stick-l"):
				velocity.x = -MOVE_SPEED
			elif Input.is_action_pressed("l-stick-r"):
				velocity.x = MOVE_SPEED
			elif Input.is_action_pressed("l-stick-u"):
				velocity.z = -MOVE_SPEED
			elif Input.is_action_pressed("l-stick-d"):
				velocity.z = MOVE_SPEED
	else:
		velocity.x = 0
		velocity.z = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.	
	#uncomment for og behaviour
	#var input_dir = Input.get_vector("l-stick-l", "l-stick-r", "l-stick-u", "l-stick-d")
#
	#if camera.orientation > 0:
		#input_dir = Input.get_vector("l-stick-u", "l-stick-d", "l-stick-r", "l-stick-l")
#
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
#
	#print(velocity)
#
	#if direction:
		#velocity.x = direction.x * SPEED * speed_buff
		#velocity.z = direction.z * SPEED * speed_buff
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
