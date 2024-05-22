extends CharacterBody3D
class_name CameraControl

const ROTATION_SPEED = 10
const ZOOM_SPEED = 7.5

const DEFAULT_POS = 0
const DEFAULT_X_ROT = -30
const DEFAULT_Y_ROT = 45
const DEFAULT_ZOOM = 2.5

const CHANGE_X_ROT = 50
const CHANGE_Y_ROT = 45
const CHANGE_ZOOM = 1.5

var pos = DEFAULT_POS
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
	return false

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
	pass

func controlCamera(direction, dir):
	match direction:
		1:
			print("left rotation")
			if pos == DEFAULT_POS: # initial position
				pos += 1
				y_rot += CHANGE_Y_ROT
				x_rot -= CHANGE_X_ROT
			elif pos > DEFAULT_POS: # overflow
				pass
			else:
				pos = DEFAULT_POS
				y_rot = DEFAULT_Y_ROT
				x_rot = DEFAULT_X_ROT
		-1:
			print("right rotation")
			if pos == DEFAULT_POS:
				pos -= 1
				y_rot -= CHANGE_Y_ROT
				x_rot -= CHANGE_X_ROT
			elif pos < DEFAULT_POS:
				pass
			else:
				pos = DEFAULT_POS
				y_rot = DEFAULT_Y_ROT
				x_rot = DEFAULT_X_ROT

	
	match dir:
		1:
			print("zoom in")
			if zoom == DEFAULT_ZOOM: # initial position
				pass
			elif zoom < DEFAULT_ZOOM: # overflow
				zoom -= CHANGE_ZOOM
			else:
				zoom = DEFAULT_ZOOM
		-1:
			print("zoom out")
			if zoom == DEFAULT_ZOOM: # initial position
				zoom += CHANGE_ZOOM
			elif zoom > DEFAULT_ZOOM: # overflow
				pass
			else:
				zoom = DEFAULT_ZOOM
	

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
	
	if Input.is_action_just_pressed("start"):
		pos = DEFAULT_POS
		y_rot = DEFAULT_Y_ROT
		x_rot = DEFAULT_X_ROT
		zoom = DEFAULT_ZOOM
		
	if isRotating():
		rotateCamera(delta)
		
	if isZooming():
		zoomCamera(delta)

	if isMoving():
		moveCamera(delta)
