extends Node3D

@onready var robot: RobotNew = $Robot

@onready var lift: Lift = $Lift

func _ready() -> void:
	PlayerAccessInstance.player = robot
	print(str("self --> ", str(self)))
	StackedLift.new(Vector3(15.59202, 114.2, -117.2), 10.0, false, 2.6).renderInScene(self)
