extends Node3D

@onready var robot: RobotNew = $Robot

func _ready() -> void:
	PlayerAccessInstance.player = robot
