extends Node3D

@onready var robot: RobotNew = $Robot

@onready var lift: Lift = $Lift

@onready var liftMarker1: Node3D = $Mountain/LiftMarker1
@onready var liftMarker2: Node3D = $Mountain/LiftMarker2
@onready var liftMarker3: Node3D = $Mountain/LiftMarker3

func _ready() -> void:
	PlayerAccessInstance.player = robot
	print(str("diff --> ", str(liftMarker2.global_position.y - liftMarker1.global_position.y)))
	
	# StackedLift.new(Vector3(15.59202, 114.2, -117.2), 10.0, false, 2.6).renderInScene(self)
	StackedLift.new(liftMarker1.global_position, 164.08, false, 2.6, 25.0).renderInScene(self)
