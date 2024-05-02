extends CharacterBody3D
class_name CameraControl

const ROTATION_SPEED = 10
const DEFAULT_X_ROT = -30
const DEFAULT_Y_ROT = 45

var x_rot = DEFAULT_X_ROT
var y_rot = DEFAULT_Y_ROT

func initCamera():
	rotateCamera(-1)
		
func isRotating():
	var currentY = snappedf($pivot.get_rotation()[1], 0.000001)
	var newY = snappedf(deg_to_rad(y_rot), 0.000001)
	
	return currentY != newY

func rotateCamera(delta):
	var currentRotation = $pivot.get_rotation()
	var newX = deg_to_rad(x_rot)
	var newY = deg_to_rad(y_rot)
	var newRotation = Vector3(newX, newY, 0)
	
	if delta < 0:
		$pivot.set_rotation(newRotation)
	else:
		$pivot.set_rotation(currentRotation.lerp(newRotation, ROTATION_SPEED*delta))

func _process(delta):
	if Input.is_action_just_pressed("r-button"):
		y_rot += 90
	elif Input.is_action_just_pressed("l-button"):
		y_rot -= 90
	elif Input.is_action_just_pressed("start"):
		y_rot = 45
		
		
	if isRotating():
		rotateCamera(delta)
