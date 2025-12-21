extends Node3D

@onready var robot: RobotNew = $Robot

@onready var lift: Lift = $Lift

@onready var liftMarker1: Node3D = $Mountain/LiftMarker1
@onready var liftMarker2: Node3D = $Mountain/LiftMarker2
@onready var liftMarker3: Node3D = $Mountain/LiftMarker3

@onready var mountain: Mountain = $Mountain

var droneCamera: Camera3D

var navigationSequence: NavigationSequence

var actualDrone: Drone

enum CameraMode {ROBOT, DRONE}
var actualCameraMode: CameraMode

var droneTemplate: PackedScene = preload("res://asset/drone/Drone.tscn")	

var markerTemplate: PackedScene = preload("res://PathMarker.tscn")	

func _process(delta: float) -> void:		
	checkSwitchCamera()
		
func checkSwitchCamera() -> void:	
	if Input.is_action_just_released("cameraMode"):
		if actualCameraMode == CameraMode.ROBOT:
			switchCamera(CameraMode.DRONE)			
		else:
			switchCamera(CameraMode.ROBOT)

func switchCamera(mode: CameraMode) -> void:	
	actualCameraMode = mode
	print(str("switch camera to --> "), str(actualCameraMode))
	match actualCameraMode:
		CameraMode.ROBOT:
			robot.camera.current = true
			droneCamera.current= false
		CameraMode.DRONE:
			robot.camera.current = false
			droneCamera.current= true

func _ready() -> void:	
	
	actualCameraMode = CameraMode.ROBOT
	
	PlayerAccessInstance.player = robot
	print(str("diff --> ", str(liftMarker2.global_position.y - liftMarker1.global_position.y)))
	StackedLift.new(liftMarker1.global_position, 164.08, false, 2.6, 25.0).renderInScene(self)
		
	navigationSequence = NavigationSequence.new(mountain, "NavMarker", true, self)	
	
	var tmp = navigationSequence.bezier(1)
	for a:Vector3 in tmp:
		var marker = markerTemplate.instantiate()
		marker.global_position = a
		add_child(marker)
		pass
	
	actualDrone = putDrone()
	droneCamera = actualDrone.camera
	
	robot.navigationSequence = NavigationSequence.new(mountain, "ConeNav", true, self)	

func putDrone() -> Drone:
	var drone: Drone = droneTemplate.instantiate()
	drone.global_position = navigationSequence.getPosition(1)
	drone.navigationSequence = navigationSequence
	add_child(drone)
	return drone
