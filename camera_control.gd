extends CharacterBody3D
class_name CameraControl

const ROTATION_SPEED = 10
const ZOOM_SPEED = 7.5
const MOVE_SPEED = 10

const DEFAULT_POSITION = Vector3(0, 0, 20)
const DEFAULT_ORIENTATION = 0
const DEFAULT_X_ROT = -30
const DEFAULT_Y_ROT = 45
const DEFAULT_ZOOM = 4.0

const CHANGE_X_ROT = 50
const CHANGE_Y_ROT = 45
const CHANGE_ZOOM = 1
const CHANGE_POS = .075

var pos = DEFAULT_POSITION
var orientation = DEFAULT_ORIENTATION
var x_rot = DEFAULT_X_ROT
var y_rot = DEFAULT_Y_ROT
var zoom = DEFAULT_ZOOM

var camera : Camera

func initCamera(my_camera : Camera):
	camera = my_camera
	camera.size = DEFAULT_ZOOM
	rotateCamera(-1)
		
func isRotating():
	var currentY = snappedf($pivot.get_rotation()[1], 0.000001)
	var newY = snappedf(deg_to_rad(y_rot), 0.000001)
	
	return currentY != newY
	
func isZooming():
	return camera.size != zoom;
	
func isMoving():
	return camera.transform.origin != pos

func rotateCamera(delta):
	var currentRotation = $pivot.get_rotation()
	var newX = deg_to_rad(x_rot)
	var newY = deg_to_rad(y_rot)
	var newRotation = Vector3(newX, newY, 0)
	
	if delta < 0:
		$pivot.set_rotation(newRotation)
	else:
		$pivot.set_rotation(currentRotation.lerp(newRotation, ROTATION_SPEED*delta))

func zoomCamera(delta):
	camera.size = lerp(camera.size, zoom, ZOOM_SPEED*delta)
	
func moveCamera(delta):
	var target_position = Vector3(pos.x, pos.y, 20)
	camera.transform.origin = camera.transform.origin.lerp(target_position, MOVE_SPEED*delta)

func controlCamera(rotate, move):
	match rotate:
		1:
			print("left rotation")
			if orientation == DEFAULT_ORIENTATION: # initial position
				orientation += 1
				y_rot += CHANGE_Y_ROT
				x_rot -= CHANGE_X_ROT
			elif orientation > DEFAULT_ORIENTATION: # overflow
				pass
			else:
				orientation = DEFAULT_ORIENTATION
				y_rot = DEFAULT_Y_ROT
				x_rot = DEFAULT_X_ROT
		-1:
			print("right rotation")
			if orientation == DEFAULT_ORIENTATION:
				orientation -= 1
				y_rot -= CHANGE_Y_ROT
				x_rot -= CHANGE_X_ROT
			elif orientation < DEFAULT_ORIENTATION:
				pass
			else:
				orientation = DEFAULT_ORIENTATION
				y_rot = DEFAULT_Y_ROT
				x_rot = DEFAULT_X_ROT

	match move:
		1:
			print("zoom in")
			if zoom + CHANGE_ZOOM == DEFAULT_ZOOM: # overflow
				pass
			elif zoom >= DEFAULT_ZOOM - 1 : # initial position
				zoom -= CHANGE_ZOOM
		-1:
			print("zoom out")
			if zoom == DEFAULT_ZOOM: # initial position
				zoom += CHANGE_ZOOM
			elif zoom > DEFAULT_ZOOM: # overflow
				pass
			else:
				zoom = DEFAULT_ZOOM

func controlCamera2(y, x):
	match y:
		1:
			print("y+")
			pos += Vector3(0, CHANGE_POS, 0)
		-1:
			print("y-")
			pos += Vector3(0, -CHANGE_POS, 0)

	match x:
		1:
			print("x+")
			pos += Vector3(CHANGE_POS, 0, 0)
		-1:
			print("x-")
			pos += Vector3(-CHANGE_POS, 0, 0)

func _process(delta):
	if Input.is_action_pressed("x-button"):
		if Input.is_action_just_pressed("d-left"):
			controlCamera(1, 0)
		elif Input.is_action_just_pressed("d-right"):
			controlCamera(-1, 0)
		elif Input.is_action_just_pressed("d-up"):
			controlCamera(0, 1)
		elif Input.is_action_just_pressed("d-down"):
			controlCamera(0, -1)
	else:
		if Input.is_action_pressed("d-up"):
			controlCamera2(1, 0)
		if Input.is_action_pressed("d-down"):
			controlCamera2(-1, 0)
		if Input.is_action_pressed("d-left"):
			controlCamera2(0, -1)
		if Input.is_action_pressed("d-right"):
			controlCamera2(0, 1)
	
	if Input.is_action_just_pressed("start"):
		orientation = DEFAULT_ORIENTATION
		y_rot = DEFAULT_Y_ROT
		x_rot = DEFAULT_X_ROT
		zoom = DEFAULT_ZOOM
		pos = DEFAULT_POSITION
		
	if isRotating():
		rotateCamera(delta)
		
	if isZooming():
		zoomCamera(delta)

	if isMoving():
		moveCamera(delta)
