class_name PathFollower
extends Node3D

var character: FollowPathDrone
var bezierifier: Bezierifier
var path: Path3D
var rawPoints: Array[Vector3]
var bakedPoints: Array[Vector3]
var pathFollow3D: PathFollow3D

const PATH_DURATION = 15.0

func _init(_character: FollowPathDrone, _rawPoints: Array[Vector3]) -> void:
	character = _character
	character.initCamera()
	rawPoints = _rawPoints	
	bezierifier = Bezierifier.new()
	for p in rawPoints:
		bezierifier.addPoint(p)
	bakedPoints = bezierifier.bakePoints()
	initPath()	
	for baked in bakedPoints:
		path.curve.add_point(baked)

func initPath() -> void:
	path = Path3D.new()
	path.curve = Curve3D.new()
	pathFollow3D = PathFollow3D.new()
	path.add_child(pathFollow3D)
	pathFollow3D.add_child(character)

func followPath() -> void:
	create_tween().tween_property(pathFollow3D, "progress_ratio", 1, PATH_DURATION)		

func tick() -> void:
	print(character.global_position)
