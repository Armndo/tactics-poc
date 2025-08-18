extends Node2D

@onready var denam = $denam

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	denam.play("idle_walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
