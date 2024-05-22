extends Node3D

var character : Character
var camera : CameraControl
# Called when the node enters the scene tree for the first time.
func _ready():
	character = $character
	camera = $cameraControl
	character.configure(camera)
	print(character)
	print(camera)
	
